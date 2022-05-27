import Foundation
import OpenCombine
import CoreDomain
import SANLegacyLibrary
import CoreFoundationLib
import TransferOperatives
import SANPLLibrary

protocol PLInternalTransferOperativeExternalDependenciesResolver {
    func resolve() -> PLTransfersRepository
    func resolve() -> PLAccountOtherOperativesInfoRepository
    func resolve() -> GlobalPositionDataRepository
    func resolve() -> DependenciesResolver
}

struct PLInternalTransferPreSetupUseCase {
    let transfersRepository: PLTransfersRepository
    let globalPositionRepository: GlobalPositionDataRepository
    
    init(dependencies: PLInternalTransferOperativeExternalDependenciesResolver) {
        self.transfersRepository = dependencies.resolve()
        self.globalPositionRepository = dependencies.resolve()
    }
}

extension PLInternalTransferPreSetupUseCase: InternalTransferPreSetupUseCase {
    func fetchPreSetup() -> AnyPublisher<PreSetupData, InternalTransferOperativeError> {
        Publishers.Zip(
            globalPositionRepository.getMergedGlobalPosition().setFailureType(to: Error.self),
            transfersRepository.getAccountsForDebitSwitch()
        )
            .mapError { _ in
                return InternalTransferOperativeError.network
            }
            .flatMap { globalPosition, debitAccounts -> AnyPublisher<PreSetupData, InternalTransferOperativeError> in
                let notVisiblesPGAccounts = globalPosition.accounts.filter { $0.isVisible == false }
                let notVisiblesPGSavingAccounts = globalPosition.savingsProducts.filter { $0.isVisible == false }
                let gpNotVisibleAccounts = notVisiblesPGAccounts.map { account in
                    return account.product
                }
                let gpNotVisibleSavingAccounts = notVisiblesPGSavingAccounts.map { savingAccount in
                    return savingAccount.product
                }
                let (originAccountsVisibles, originAccountsNotVisibles) = originAccounts(accounts: debitAccounts, gpNotVisibleAccounts: gpNotVisibleAccounts, gpNotVisibleSavingAccounts: gpNotVisibleSavingAccounts)
                if isMinimunAccounts(accounts: originAccountsVisibles + originAccountsNotVisibles) == false {
                    return Fail(error: InternalTransferOperativeError.originMinimunAccounts).eraseToAnyPublisher()
                }
                let data = PreSetupData(accountsVisibles: originAccountsVisibles,
                                        accountsNotVisibles: originAccountsNotVisibles)
                return Just(data).setFailureType(to: InternalTransferOperativeError.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

private extension PLInternalTransferPreSetupUseCase {
    func isMinimunAccounts(accounts: [AccountRepresentable]) -> Bool {
        if !accounts.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func originAccounts(accounts: [AccountRepresentable], gpNotVisibleAccounts: [AccountRepresentable], gpNotVisibleSavingAccounts: [SavingProductRepresentable]) -> ([AccountRepresentable], [AccountRepresentable]) {
        var originAccountsVisibles: [AccountRepresentable] = []
        var originAccountsNotVisibles: [AccountRepresentable] = []
        accounts.forEach { account in
            let polandAccount = account as? PolandAccountRepresentable
            let containsAccountNotVisible = gpNotVisibleAccounts.contains { accountNotVisibles in
                return polandAccount?.ibanRepresentable?.codBban.contains(accountNotVisibles.ibanRepresentable?.codBban ?? "") ?? false
            }
            let containsSavingAccountNotVisible = gpNotVisibleSavingAccounts.contains { accountNotVisibles in
                return polandAccount?.ibanRepresentable?.codBban.contains(accountNotVisibles.ibanRepresentable?.codBban ?? "") ?? false
            }
            guard containsAccountNotVisible || containsSavingAccountNotVisible else {
                originAccountsVisibles.append(account)
                return
            }
            originAccountsNotVisibles.append(account)
        }
        return (originAccountsVisibles, originAccountsNotVisibles)
    }
}
