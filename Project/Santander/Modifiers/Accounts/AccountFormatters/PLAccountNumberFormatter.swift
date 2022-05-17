//
//  PLAccountNumberFormatter.swift
//  Santander
//

import Foundation
import CoreFoundationLib
import PLCommons
import CoreDomain

final class PLAccountNumberFormatter: AccountNumberFormatterProtocol {
    func accountNumberFormat(_ account: AccountRepresentable?) -> String {
        return IBANFormatter.format(iban: account?.getIBANString)
    }
    func accountNumberFormat(_ entity: AccountEntity?) -> String {
        return IBANFormatter.format(iban: entity?.getIban()?.ibanString)
    }
    
    func accountNumberFormat(_ entity: AccountDetailEntity?) -> String {
        return IBANFormatter.format(iban: entity?.accountId)
    }
    
    func accountNumberFormat(_ accountNumber: String?) -> String {
        return IBANFormatter.format(iban: accountNumber)
    }
    
    func getIBANFormatted(_ iban: IBANEntity?) -> String {
        return IBANFormatter.format(iban: iban?.ibanString)
    }
    
    func getIBANFormatted(_ iban: IBANRepresentable?) -> String {
        return IBANFormatter.format(iban: iban?.ibanString)
    }
    
    func accountNumberShortFormat(_ account: AccountEntity?) -> String {
        guard let accountId = account?.contractNumber?.replace(" ", ""), accountId.count > 4 else {
            return ""
        }
        return "*" + (accountId.substring(accountId.count - 4) ?? "*")
    }
}
