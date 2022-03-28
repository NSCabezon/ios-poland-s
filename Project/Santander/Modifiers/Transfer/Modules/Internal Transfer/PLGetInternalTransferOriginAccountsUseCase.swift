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
    func filterAccounts(input: GetInternalTransferOriginAccountsUseCaseInput)
    -> AnyPublisher<GetInternalTransferOriginAccountsFilteredUseCaseOutput, Never> {
        let inputAccounts: [AccountRepresentable] = input.visibleAccounts + input.notVisibleAccounts
        return Just(inputAccounts)
            .eraseToAnyPublisher()
            .map { $0.compactMap { $0 as? PolandAccountRepresentable } }
            .map(removeUniqueNonCreditCardAccount)
            .map(removeCreditCardAccountsIfNecessary)
            .map { reclassifyWithUserPrefs(polandAccounts: $0, input: input) }
            .map { output in
                return GetInternalTransferOriginAccountsFilteredUseCaseOutput(
                    visiblesFiltered: output.0,
                    notVisiblesFiltered: output.1
                )
            }
            .eraseToAnyPublisher()
    }
}

private extension PLGetInternalTransferOriginAccountsUseCase {
    /// Remove the unique account found in an array of Poland accounts if it's the
    /// only one that is not credit card.
    /// - Parameter polandAccounts: an array of Poland accounts.
    /// - Returns: an array of Poland accounts filtered.
    func removeUniqueNonCreditCardAccount(polandAccounts: [PolandAccountRepresentable]) -> [PolandAccountRepresentable] {
        let creditCardAccounts = polandAccounts.filter { $0.type == .creditCard }
        if creditCardAccounts.count == polandAccounts.count - 1 {
            return creditCardAccounts
        } else {
            return polandAccounts
        }
    }
    
    /// Remove all the credit card accounts of an array if the accounts that are
    /// not credit card are also not PLN.
    /// - Parameter polandAccounts: array of Poland accounts.
    /// - Returns: an array of Poland accounts filtered.
    func removeCreditCardAccountsIfNecessary(polandAccounts: [PolandAccountRepresentable]) -> [PolandAccountRepresentable] {
        let notCreditCardAccounts = polandAccounts.filter { $0.type != .creditCard }
        if notCreditCardAccounts.contains(where: { $0.currencyCode == "PLN" }) {
            return polandAccounts
        } else {
            return notCreditCardAccounts
        }
    }
    
    func reclassifyWithUserPrefs(polandAccounts: [PolandAccountRepresentable], input: GetInternalTransferOriginAccountsUseCaseInput) -> ([AccountRepresentable], [AccountRepresentable]) {
        var visibleAccounts: [AccountRepresentable] = []
        var notVisibleAccounts: [AccountRepresentable] = []
        for account in polandAccounts {
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
        return (visibleAccounts, notVisibleAccounts)
    }
}
