//
//  InternalTransferPreSetupUseCase.swift
//  TransferOperatives
//
//  Created by Cristobal Ramos Laina on 15/2/22.
//

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
            .flatMap { globalPosition, debitAccounts, creditAccounts -> AnyPublisher<PreSetupData, InternalTransferOperativeError> in
                let notVisiblesPGAccounts = globalPosition.accounts.filter { $0.isVisible == false }
                let gpNotVisibleAccounts = notVisiblesPGAccounts.map { account in
                    return account.product
                }
                let (originAccountsVisibles, originAccountsNotVisibles, notOriginCreditCardAccount) = originAccounts(accounts: debitAccounts, gpNotVisibleAccounts: gpNotVisibleAccounts)
                if isMinimunAccounts(accounts: originAccountsVisibles + originAccountsNotVisibles) == false {
                    return Fail(error: InternalTransferOperativeError.minimunAccounts).eraseToAnyPublisher()
                }
                if creditCardAccountConditions(notOriginCreditCardAccount) == false {
                    return Fail(error: InternalTransferOperativeError.genericError).eraseToAnyPublisher()
                }
                let (destinationAccountsVisibles, destinationAccountsNotVisibles) = destinationAccounts(accounts: creditAccounts, gpNotVisibleAccounts: gpNotVisibleAccounts)
                let data = PreSetupData(originAccountsVisibles: originAccountsVisibles,
                                    originAccountsNotVisibles: originAccountsNotVisibles,
                                    destinationAccountsVisibles: destinationAccountsVisibles,
                                    destinationAccountsNotVisibles: destinationAccountsNotVisibles)
                return Just(data).setFailureType(to: InternalTransferOperativeError.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func isMinimunAccounts(accounts: [AccountRepresentable]) -> Bool {
        if accounts.count > 1 {
            return true
        } else {
            return false
        }
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
    
    func originAccounts(accounts: [AccountRepresentable], gpNotVisibleAccounts: [AccountRepresentable]) -> ([AccountRepresentable], [AccountRepresentable], [AccountRepresentable]) {
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
    
    func destinationAccounts(accounts: [AccountRepresentable], gpNotVisibleAccounts: [AccountRepresentable]) -> ([AccountRepresentable], [AccountRepresentable]) {
        var destinationAccountsVisibles: [AccountRepresentable] = []
        var destinationAccountsNotVisibles: [AccountRepresentable] = []
        var notDestinationCreditCardAccount: [AccountRepresentable] = []
        accounts.forEach { account in
            let polandAccount = account as? PolandAccountRepresentable
            if polandAccount?.type != .creditCard {
                notDestinationCreditCardAccount.append(account)
            }
            let containsAccountNotVisible = gpNotVisibleAccounts.contains { accountNotVisibles in
                return polandAccount?.ibanRepresentable?.codBban.contains(accountNotVisibles.ibanRepresentable?.codBban ?? "") ?? false
            }
            guard containsAccountNotVisible else {
                destinationAccountsVisibles.append(account)
                return
            }
            destinationAccountsNotVisibles.append(account)
        }
        return (destinationAccountsVisibles, destinationAccountsNotVisibles)
    }
}
