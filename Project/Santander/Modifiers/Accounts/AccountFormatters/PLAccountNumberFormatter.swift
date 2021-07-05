//
//  PLAccountNumberFormatter.swift
//  Santander
//

import Foundation
import Models
import Commons

final class PLAccountNumberFormatter: AccountNumberFormatterProtocol {
    func accountNumberFormat(_ entity: AccountEntity?) -> String {
        return self.getIBANFormatted(entity?.getIban())
    }
    
    func accountNumberFormat(_ entity: AccountDetailEntity?) -> String {
        guard let accountNumber = entity?.accountId,
              let firsPart = accountNumber.substring(0, 4) else {
            return ""
        }
        guard let secondPart = accountNumber.substring(4) else {
            return firsPart
        }
        return "\(firsPart) \(secondPart)"
    }
    
    func getIBANFormatted(_ iban: IBANEntity?) -> String {
        guard let iban = iban else {
            return ""
        }
        let ibanString = "\(iban.dto.checkDigits)\(iban.dto.codBban)"
        let ibantrim = ibanString.replacingOccurrences(of: " ", with: "")
        let numberOfGroups: Int = ibantrim.count / 4
        var printedIban = String(ibantrim.prefix(4))
        for iterator in 1..<numberOfGroups {
            let firstIndex = ibantrim.index(ibantrim.startIndex, offsetBy: 4*iterator)
            let secondIndex = ibantrim.index(ibantrim.startIndex, offsetBy: 4*(iterator+1) - 1)
            printedIban += " \(ibantrim[firstIndex...secondIndex])"
        }
        if ibantrim.count > 4*numberOfGroups {
            printedIban += " \(ibantrim.suffix(ibantrim.count - 4*numberOfGroups))"
        }
        return "\(iban.dto.countryCode) \(printedIban)"
    }
    
    func accountNumberShortFormat(_ account: AccountEntity?) -> String {
        guard let accountId = account?.contractNumber?.replace(" ", ""), accountId.count > 4 else {
            return ""
        }
        return "*" + (accountId.substring(accountId.count - 4) ?? "*")
    }
}
