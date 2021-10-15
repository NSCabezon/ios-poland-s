//
//  PLNumberFormatter.swift
//  Santander

import Commons
import SANLegacyLibrary

public final class PLNumberFormatter: AmountFormatterProvider {
    
    public init() {}
    
    public func formatterForRepresentation(_ amountRepresentation: AmountRepresentation) -> NumberFormatter? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.locale = Locale(identifier: "pl_PL")
        return numberFormatter
    }
}

extension PLNumberFormatter: CurrencyFormatterProvider {
    public var defaultCurrency: CurrencyType {
        return .złoty
    }

    public var decimalSeparator: Character {
        return ","
    }

    public func assembleCurrencyString(for value: String, with symbol: String, representation: AmountRepresentation) -> CurrencySymbolPosition {
        return .rightPadded
    }
}
