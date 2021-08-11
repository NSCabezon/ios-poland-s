//
//  PLAccountDetailModifier.swift
//  Santander
//

import Foundation
import Models
import Commons
import PLCommons
import Account

final class PLAccountDetailModifier: AccountDetailModifierProtocol {
    var isEnabledEditAlias: Bool {
        return true
    }
    
    var isEnabledAccountHolder: Bool {
        return false
    }
    
    func customAccountDetailBuilder(data: AccountDetailDataViewModel, isEnabledEditAlias: Bool) -> [AccountDetailProduct]? {
        let builder = AccountDetailBuilder()
            .addIban(iban: data.iban)
            .addAccountName(accountName: data.accountName, isEnabledEditAlias: isEnabledEditAlias)
            .addInterestRate(interestRate: data.interestRate)
            .addCurrentBalance(currentBalance: data.currentbalance)
            .addOverdraft(overdraft: data.overdraft)
        return builder.build()
    }
}
