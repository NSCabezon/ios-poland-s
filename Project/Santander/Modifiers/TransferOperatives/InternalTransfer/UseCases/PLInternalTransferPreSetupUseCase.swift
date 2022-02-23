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
        Publishers.Zip(
            globalPositionRepository.getMergedGlobalPosition().setFailureType(to: Error.self),
            transfersRepository.getAccountForDebit()
        )
            .tryMap { response -> PreSetupData in
                var visibles: [AccountRepresentable] = []
                var notVisibles: [AccountRepresentable] = []
                var notCreditCardAccount: [AccountRepresentable] = []
                let accounts = response.1
                let notVisiblesPGAccounts = response.0.accounts.filter { $0.isVisible == false }
                let gpNotVisibleAccounts = notVisiblesPGAccounts.map { account in
                    return account.product
                }
                accounts.forEach { account in
                    let polandAccount = account as? PolandAccountRepresentable
                    if polandAccount?.type != .creditCard {
                        notCreditCardAccount.append(account)
                    }
                    let containsAccountNotVisible = gpNotVisibleAccounts.contains { accountNotVisibles in
                        return polandAccount?.ibanRepresentable?.codBban.contains(accountNotVisibles.ibanRepresentable?.codBban ?? "") ?? false
                    }
                    guard containsAccountNotVisible else {
                        visibles.append(account)
                        return
                    }
                    notVisibles.append(account)
                }
                if isMinimunAccounts(accounts: visibles + notVisibles) == false {
                    throw NSError()
                }
                if creditCardAccountConditions(notCreditCardAccount) == false {
                    throw NSError()
                }
                return PreSetupData(accountsVisibles: visibles, accountsNotVisibles: notVisibles)
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
