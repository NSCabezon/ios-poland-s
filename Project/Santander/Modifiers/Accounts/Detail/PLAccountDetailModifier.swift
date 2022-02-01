//
//  PLAccountDetailModifier.swift
//  Santander
//

import Foundation
import CoreFoundationLib
import CoreFoundationLib
import PLCommons
import Account

final class PLAccountDetailModifier: AccountDetailModifierProtocol {
    var isEnabledMillionFormat: Bool {
        return true
    }
    
    var maxAliasLength: Int {
        return 40
    }
    
    var regExValidatorString: CharacterSet {
        return CharacterSet(charactersIn: "1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNMąęćółńśżźĄĘĆÓŁŃŚŻŹ-.:,;/& ")
    }
        
    var isEnabledEditAlias: Bool {
        return true
    }
    
    var isEnabledAccountHolder: Bool {
        return false
    }
    
    func customAccountDetailBuilder(data: AccountDetailDataViewModel, isEnabledEditAlias: Bool) -> [AccountDetailProduct]? {
        let builder = AccountDetailBuilder()
            .addIban(iban: data.iban)
            .addAccountName(accountName: data.accountName, isEnabledEditAlias: isEnabledEditAlias, maxAliasLength: maxAliasLength, regExValidatorString: regExValidatorString)
            .addInterestRate(interestRate: data.interestRate)
            .addCurrentBalance(currentBalance: data.currentbalance)
            .addOverdraft(overdraft: data.overdraft)
        return builder.build()
    }
}
