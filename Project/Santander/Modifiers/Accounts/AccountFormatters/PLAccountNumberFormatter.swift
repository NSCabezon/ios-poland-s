//
//  PLAccountNumberFormatter.swift
//  Santander
//

import Foundation
import Models
import Commons

final class PLAccountNumberFormatter: AccountNumberFormatterProtocol {
    func accountNumberFormat(_ entity: AccountEntity?) -> String {
        return self.getAccountNumberFormatted(entity?.getIban()?.ibanString)
    }
    
    func accountNumberFormat(_ entity: AccountDetailEntity?) -> String {
        return self.getAccountNumberFormatted(entity?.accountId)
    }
    
    func getIBANFormatted(_ iban: IBANEntity?) -> String {
        return self.getAccountNumberFormatted(iban?.ibanString)
    }
    
    func accountNumberShortFormat(_ account: AccountEntity?) -> String {
        guard let accountId = account?.contractNumber?.replace(" ", ""), accountId.count > 4 else {
            return ""
        }
        return "*" + (accountId.substring(accountId.count - 4) ?? "*")
    }

    func getAccountNumberFormatted(_ number: String?) -> String {
        guard let number = number else {
            return ""
        }
        let beginIndex = Int(String(number.substring(0, 2) ?? "")) != nil ? 2 : 4
        let countryCode = String(number.substring(0, beginIndex) ?? "")
        let ibanCode = String(number.substring(beginIndex) ?? "")
        let numberOfGroups: Int = ibanCode.count / 4
        var printedIban = String(ibanCode.prefix(4))
        for iterator in 1..<numberOfGroups {
            let firstIndex = ibanCode.index(ibanCode.startIndex, offsetBy: 4*iterator)
            let secondIndex = ibanCode.index(ibanCode.startIndex, offsetBy: 4*(iterator+1) - 1)
            printedIban += " \(ibanCode[firstIndex...secondIndex])"
        }
        if ibanCode.count > 4*numberOfGroups {
            printedIban += " \(ibanCode.suffix(ibanCode.count - 4*numberOfGroups))"
        }
        return "\(countryCode) \(printedIban)"
    }
}
