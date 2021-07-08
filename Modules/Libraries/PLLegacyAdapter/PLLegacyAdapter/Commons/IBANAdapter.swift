//
//  IBANAdapter.swift
//  PLLegacyAdapter
//

import Foundation

public final class IBANAdapter {
    public static func adaptIBANToIBANFormatted(_ iban: String?) -> String? {
        guard let iban = iban else {
            return ""
        }
        let beginIndex = Int(String(iban.substring(0, 2) ?? "")) != nil ? 2 : 4
        let countryCode = String(iban.substring(0, beginIndex) ?? "")
        let ibanCode = String(iban.substring(beginIndex) ?? "")
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
