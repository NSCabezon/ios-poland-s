import TransferOperatives
import SANPLLibrary
import OpenCombine
import CoreDomain

protocol PLGetInternalTransferDestAccountsUseCaseDependenciesResolver {
    func resolve() -> PLTransfersRepository
    func resolve() -> GlobalPositionDataRepository
}

struct PLGetInternalTransferDestAccountsUseCase {
    let transfersRepository: PLTransfersRepository
    let globalPositionRepository: GlobalPositionDataRepository
    
    init(dependencies: PLGetInternalTransferDestAccountsUseCaseDependenciesResolver) {
        self.transfersRepository = dependencies.resolve()
        self.globalPositionRepository = dependencies.resolve()
    }
}

extension PLGetInternalTransferDestAccountsUseCase: GetInternalTransferDestinationAccountsUseCase {
    func fetchAccounts(_ originAccount: AccountRepresentable) -> AnyPublisher<GetInternalTransferDestinationAccountsOutput, Never> {
        return Publishers.Zip(
            globalPositionRepository.getMergedGlobalPosition(),
            transfersRepository.getAccountsForCredit()
                .replaceError(with: [])
                .eraseToAnyPublisher()
        )
        .map { globalPosition, accounts in
            return getAccounts(globalPosition, accounts: accounts)
        }
        .map { accountsCount, visibleAccounts, notVisibleAccounts in
            return (
                accountsCount,
                getFilteredAccounts(from: visibleAccounts, originAccount: originAccount),
                getFilteredAccounts(from: notVisibleAccounts, originAccount: originAccount)
            )
        }
        .map { accountsCount, visibleAccounts, notVisibleAccounts in
            return filterDestinationAccounts(
                originalAccountsCount: accountsCount,
                visibleAccounts: visibleAccounts,
                notVisibleAccounts: notVisibleAccounts,
                originAccount: originAccount
            )
        }
        .eraseToAnyPublisher()
    }
}

private extension PLGetInternalTransferDestAccountsUseCase {
    
    func getAccounts(_ globalPosition: GlobalPositionAndUserPrefMergedRepresentable, accounts: [AccountRepresentable]) -> (Int, [AccountRepresentable], [AccountRepresentable]) {
        var visibleAccounts: [PolandAccountRepresentable] = []
        var notVisibleAccounts: [PolandAccountRepresentable] = []
        let gpNotVisibleAccounts = globalPosition.accounts.filter { !$0.isVisible }.map { $0.product }
        accounts.forEach { account in
            guard let polandAccount = account as? PolandAccountRepresentable else { return }
            let containsAccountNotVisible = gpNotVisibleAccounts.contains { notVisibleAccount in
                guard let lhsIban = polandAccount.ibanRepresentable,
                      let rhsIban = notVisibleAccount.ibanRepresentable
                else { return false }
                return lhsIban.codBban.contains(rhsIban.codBban)
            }
            if containsAccountNotVisible {
                notVisibleAccounts.append(polandAccount)
            } else {
                visibleAccounts.append(polandAccount)
            }
        }
        return (globalPosition.accounts.count, visibleAccounts, notVisibleAccounts)
        
    }
    func getFilteredAccounts(from accounts: [AccountRepresentable], originAccount: AccountRepresentable) -> [PolandAccountRepresentable] {
        let accounts = accounts.filter { !$0.equalsTo(other: originAccount) }
        return filterCreditCardAccounts(from: accounts)
    }
    
    func filterCreditCardAccounts(from accounts: [AccountRepresentable]) -> [PolandAccountRepresentable] {
        guard let polandAccounts: [PolandAccountRepresentable] = accounts as? [PolandAccountRepresentable] else { return [] }
        return polandAccounts.filter { $0.type != .creditCard }
    }
    
    func filterDestinationAccounts(originalAccountsCount: Int,
                                   visibleAccounts: [PolandAccountRepresentable],
                                   notVisibleAccounts: [PolandAccountRepresentable],
                                   originAccount: AccountRepresentable) -> GetInternalTransferDestinationAccountsOutput {
        guard let originAccount = originAccount as? PolandAccountRepresentable,
              originAccount.type == .creditCard else {
            return GetInternalTransferDestinationAccountsOutput(
                visibleAccounts: visibleAccounts,
                notVisibleAccounts: notVisibleAccounts,
                didFilterAccounts: hasFilteredAccounts(
                    originalAccountsCount: originalAccountsCount,
                    visibleAccounts: visibleAccounts,
                    notVisibleAccounts: notVisibleAccounts
                )
            )
        }
        let visiblesFiltered = visibleAccounts.filter { $0.currencyRepresentable?.currencyType == .złoty }
        let notVisiblesFiltered = notVisibleAccounts.filter { $0.currencyRepresentable?.currencyType == .złoty }
        return GetInternalTransferDestinationAccountsOutput(
            visibleAccounts: visiblesFiltered,
            notVisibleAccounts: notVisiblesFiltered,
            didFilterAccounts: hasFilteredAccounts(
                originalAccountsCount: originalAccountsCount,
                visibleAccounts: visibleAccounts,
                notVisibleAccounts: notVisibleAccounts
            )
        )
    }
    
    func hasFilteredAccounts(originalAccountsCount: Int, visibleAccounts: [AccountRepresentable], notVisibleAccounts: [AccountRepresentable]) -> Bool {
        let totalItems = visibleAccounts.count + notVisibleAccounts.count
        return (originalAccountsCount - 1) > totalItems
    }
}
