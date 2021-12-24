//
//  PLAccountDetailModifier.swift
//  Santander
//

import Foundation
import CoreFoundationLib
import Commons
import PLCommons
import Account

final class PLAccountDetailModifier: AccountDetailModifierProtocol {
    var isEnabledMillionFormat: Bool {
        return true
    }
    
    var isEnabledEditAlias: Bool {
        return false
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
