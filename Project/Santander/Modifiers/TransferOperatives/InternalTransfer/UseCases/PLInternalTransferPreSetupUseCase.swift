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

struct PLInternalTransferPreSetupUseCase {
    let dependencies: InternalTransferOperativeExternalDependenciesResolver
    let transfersRepository: PLTransfersRepository
    
    init(dependencies: InternalTransferOperativeExternalDependenciesResolver) {
        self.dependencies = dependencies
        self.transfersRepository = dependencies.resolve().resolve()
    }
}

extension PLInternalTransferPreSetupUseCase: InternalTransferPreSetupUseCase {
    func fetchPreSetup() -> AnyPublisher<PreSetupData, Error> {
        let gpNotVisibleAccounts = dependencies.resolve().resolve(for: GlobalPositionWithUserPrefsRepresentable.self).accountsNotVisiblesWithoutPiggy
        return transfersRepository.getAccountForDebit()
            .tryMap { accounts in
            var visibles: [AccountRepresentable] = []
            var notVisibles: [AccountRepresentable] = []
                var notCreditCardAccount: [AccountRepresentable] = []
                accounts.forEach { account in
                    let polandAccount = account as? PolandAccountRepresentable
                    if polandAccount?.type != .creditCard {
                        notCreditCardAccount.append(account)
                    }
                    let containsAccountNotVisible = gpNotVisibleAccounts.contains { accountNotVisibles in
                        return polandAccount?.ibanRepresentable?.codBban.contains(accountNotVisibles.representable.ibanRepresentable?.codBban ?? "") ?? false
                    }
                    guard containsAccountNotVisible else {
                        visibles.append(account)
                        return
                    }
                    notVisibles.append(account)
                }
                if isMinimunAccounts(accounts: visibles + notVisibles) == false {
                    throw NSError(description: "sendMoney_title_cannotOperation")
                }
                if creditCardAccountConditions(notCreditCardAccount) == false {
                    throw NSError(description: "sendMoney_text_notCompatibleOperation")
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
