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
    func resolve() -> GlobalPositionDataRepository
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
    func fetchPreSetup() -> AnyPublisher<PreSetupData, Error> {
        Publishers.Zip3(
            globalPositionRepository.getMergedGlobalPosition().setFailureType(to: Error.self),
            transfersRepository.getAccountForDebit(),
            transfersRepository.getAccountForCredit()
        )
            .tryMap { response -> PreSetupData in
                var originAccountsVisibles: [AccountRepresentable] = []
                var originAccountsNotVisibles: [AccountRepresentable] = []
                var destinationAccountsVisibles: [AccountRepresentable] = []
                var destinationAccountsNotVisibles: [AccountRepresentable] = []
                var notOriginCreditCardAccount: [AccountRepresentable] = []
                var notDestinationCreditCardAccount: [AccountRepresentable] = []
                let debitAccounts = response.1
                let creditAccounts = response.2
                let notVisiblesPGAccounts = response.0.accounts.filter { $0.isVisible == false }
                let gpNotVisibleAccounts = notVisiblesPGAccounts.map { account in
                    return account.product
                }
                debitAccounts.forEach { account in
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
                creditAccounts.forEach { account in
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
                if isMinimunAccounts(accounts: originAccountsVisibles + originAccountsNotVisibles) == false {
                    throw NSError()
                }
                if creditCardAccountConditions(notOriginCreditCardAccount) == false {
                    throw NSError()
                }
                return PreSetupData(originAccountsVisibles: originAccountsVisibles, originAccountsNotVisibles: originAccountsNotVisibles, destinationAccountsVisibles: destinationAccountsVisibles, destinationAccountsNotVisibles: destinationAccountsNotVisibles)
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
}
