//
//  CurrencyAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANLegacyLibrary

public final class CurrencyAdapter {
    public func adaptStringToCurrency(_ currencyCode: String?) -> CurrencyDTO? {
        guard let currency = currencyCode,
              let currencyType = CurrencyType(rawValue: currency) else {
            return nil
        }
        return CurrencyDTO(currencyName: currency, currencyType: currencyType)
    }
}
