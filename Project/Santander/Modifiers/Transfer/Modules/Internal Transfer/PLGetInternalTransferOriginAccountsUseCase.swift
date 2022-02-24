import TransferOperatives
import SANPLLibrary
import OpenCombine
import CoreDomain

protocol PLGetInternalTransferOriginAccountsUseCaseDependenciesResolver {
    func resolve() -> PLTransfersRepository
}

struct PLGetInternalTransferOriginAccountsUseCase {
    let transfersRepository: PLTransfersRepository
    
    init(dependencies: PLInternalTransferOperativeExternalDependenciesResolver) {
        self.transfersRepository = dependencies.resolve()
    }
}

extension PLGetInternalTransferOriginAccountsUseCase: GetInternalTransferOriginAccountsFilteredUseCase {
    func filterAccounts(input: GetInternalTransferOriginAccountsUseCaseInput) -> AnyPublisher<GetInternalTransferOriginAccountsFilteredUseCaseOutput, Never> {
        return transfersRepository.getAccountForDebit()
            .replaceError(with: [])
            .map { accounts -> [AccountRepresentable] in
                let polandAccounts = accounts.compactMap { $0 as? PolandAccountRepresentable }
                let creditCardAccounts = polandAccounts.filter { $0.type == .creditCard }
                if creditCardAccounts.count == accounts.count - 1 {
                    return creditCardAccounts
                } else {
                    return accounts
                }
            }
            .map { accounts -> [AccountRepresentable] in
                let polandAccounts = accounts.compactMap { $0 as? PolandAccountRepresentable }
                let notCreditCardAccounts = polandAccounts.filter { $0.type != .creditCard }
                if notCreditCardAccounts.contains(where: { $0.currencyCode == "PLN" }) {
                    return polandAccounts
                } else {
                    return notCreditCardAccounts
                }
            }
            .map { accounts -> GetInternalTransferOriginAccountsFilteredUseCaseOutput in
                var visibleAccounts: [AccountRepresentable] = []
                var notVisibleAccounts: [AccountRepresentable] = []
                for account in accounts {
                    let containsAccountNotVisible = input.notVisibleAccounts.contains { notVisibleAccount in
                        guard let lhs = notVisibleAccount.ibanRepresentable, let rhs = account.ibanRepresentable else { return false }
                        return lhs.equalsTo(other: rhs)
                    }
                    if containsAccountNotVisible {
                        notVisibleAccounts.append(account)
                    } else {
                        visibleAccounts.append(account)
                    }
                }
                return GetInternalTransferOriginAccountsFilteredUseCaseOutput(
                    visiblesFiltered: visibleAccounts,
                    notVisiblesFiltered: notVisibleAccounts
                )
            }
            .eraseToAnyPublisher()
    }
}
