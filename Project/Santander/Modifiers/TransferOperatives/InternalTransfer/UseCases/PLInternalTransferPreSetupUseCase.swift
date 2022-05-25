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
        Publishers.Zip3(
            globalPositionRepository.getMergedGlobalPosition().setFailureType(to: Error.self),
            transfersRepository.getAccountsForDebit(),
            transfersRepository.getAccountsForCredit()
        )
            .mapError { _ in
                return InternalTransferOperativeError.network
            }
            .tryMap { (globalPosition: GlobalPositionAndUserPrefMergedRepresentable, debitAccounts: [AccountRepresentable], creditAccounts: [AccountRepresentable]) -> (Int, [PolandAccountRepresentable], [PolandAccountRepresentable]) in
                let notVisiblesPGAccounts = globalPosition.accounts.filter { $0.isVisible == false }
                let gpNotVisibleAccounts = notVisiblesPGAccounts.map { account in
                    return account.product
                }
                let (originAccountsVisibles, originAccountsNotVisibles, notOriginCreditCardAccount) = filterInputAccounts(accounts: debitAccounts, gpNotVisibleAccounts: gpNotVisibleAccounts)
                let (destinationAccountsVisibles, destinationAccountsNotVisibles, _) = filterInputAccounts(accounts: creditAccounts, gpNotVisibleAccounts: gpNotVisibleAccounts)
                if isMinimunAccounts(accounts: originAccountsVisibles + originAccountsNotVisibles) == false {
                    throw InternalTransferOperativeError.minimunAccounts
                }
                if isMinimunAccounts(accounts: destinationAccountsVisibles + destinationAccountsNotVisibles) == false {
                    throw InternalTransferOperativeError.minimunAccounts
                }
                if creditCardAccountConditions(notOriginCreditCardAccount) == false {
                    throw InternalTransferOperativeError.genericError
                }
                return (globalPosition.accounts.count, originAccountsVisibles.compactMap { $0 as? PolandAccountRepresentable }, originAccountsNotVisibles.compactMap { $0 as? PolandAccountRepresentable })
            }
            .map { accountsCount, originAccountsVisibles, originAccountsNotVisibles in
                return (
                    accountsCount,
                    removeUniqueNonCreditCardAccount(originAccountsVisibles),
                    removeUniqueNonCreditCardAccount(originAccountsNotVisibles)
                )
            }
            .map { accountsCount, originAccountsVisibles, originAccountsNotVisibles in
                return (
                    accountsCount,
                    removeCreditCardAccountsIfNecessary(originAccountsVisibles),
                    removeCreditCardAccountsIfNecessary(originAccountsNotVisibles)
                )
            }
            .map { accountsCount, originAccountsVisibles, originAccountsNotVisibles in
                let totalFilteredAccounts = originAccountsVisibles.count + originAccountsNotVisibles.count
                let hasFilteredAcccounts = accountsCount > totalFilteredAccounts
                return PreSetupData(
                    accountsVisibles: originAccountsVisibles,
                    accountsNotVisibles: originAccountsNotVisibles,
                    didFilterAccounts: hasFilteredAcccounts
                )
            }
            .mapError { error -> InternalTransferOperativeError in
                guard let error = error as? InternalTransferOperativeError else { return .genericError}
                return error
            }
            .eraseToAnyPublisher()
    }
}

private extension PLInternalTransferPreSetupUseCase {
    func isMinimunAccounts(accounts: [AccountRepresentable]) -> Bool {
        return accounts.count > 0
    }
    
    func creditCardAccountConditions(_ notCreditCardAccounts: [AccountRepresentable]) -> Bool {
        if notCreditCardAccounts.isEmpty {
            return false
        } else if notCreditCardAccounts.count == 1 && notCreditCardAccounts[0].currencyRepresentable?.currencyType != .złoty {
            return false
        } else {
            return true
        }
    }
    
    func filterInputAccounts(accounts: [AccountRepresentable], gpNotVisibleAccounts: [AccountRepresentable]) -> ([AccountRepresentable], [AccountRepresentable], [AccountRepresentable]) {
        var originAccountsVisibles: [AccountRepresentable] = []
        var originAccountsNotVisibles: [AccountRepresentable] = []
        var notOriginCreditCardAccount: [AccountRepresentable] = []
        accounts.forEach { account in
            let polandAccount = account as? PolandAccountRepresentable
            if polandAccount?.type != .creditCard {
                notOriginCreditCardAccount.append(account)
            }
            let containsAccountNotVisible = gpNotVisibleAccounts.contains { accountNotVisibles in
                return polandAccount?.ibanRepresentable?.codBban.contains(accountNotVisibles.ibanRepresentable?.codBban ?? "") ?? false
            }
            guard containsAccountNotVisible else {
                originAccountsVisibles.append(account)
                return
            }
            originAccountsNotVisibles.append(account)
        }
        return (originAccountsVisibles, originAccountsNotVisibles, notOriginCreditCardAccount)
    }
    
    /// Remove the unique account found in an array of Poland accounts if it's the
    /// only one that is not credit card.
    /// - Parameter polandAccounts: an array of Poland accounts.
    /// - Returns: an array of Poland accounts filtered.
    func removeUniqueNonCreditCardAccount(_ polandAccounts: [PolandAccountRepresentable]) -> [PolandAccountRepresentable] {
        let creditCardAccounts = polandAccounts.filter { $0.type == .creditCard }
        guard creditCardAccounts.count == polandAccounts.count - 1 else {
            return polandAccounts
        }
        return creditCardAccounts
    }
    
    /// Remove all the credit card accounts of an array if the accounts that are
    /// not credit card are also not PLN.
    /// - Parameter polandAccounts: array of Poland accounts.
    /// - Returns: an array of Poland accounts filtered.
    func removeCreditCardAccountsIfNecessary(_ polandAccounts: [PolandAccountRepresentable]) -> [PolandAccountRepresentable] {
        let notCreditCardAccounts = polandAccounts.filter { $0.type != .creditCard }
        guard !notCreditCardAccounts.isEmpty else { return polandAccounts }
        guard !notCreditCardAccounts.contains(where: { $0.currencyCode == "PLN" }) else {
            return polandAccounts
        }
        return notCreditCardAccounts
    }
}
