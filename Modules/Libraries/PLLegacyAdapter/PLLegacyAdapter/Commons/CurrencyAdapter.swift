//
//  CurrencyAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANLegacyLibrary

public final class CurrencyAdapter {
    public func adaptStringToCurrency(_ currencyCode: String?) -> CurrencyDTO? {
        guard let currency = currencyCode else {
            return nil
        }
        let currencyType = CurrencyType.parse(currency)
        return CurrencyDTO(currencyName: currency, currencyType: currencyType)
    }
}
