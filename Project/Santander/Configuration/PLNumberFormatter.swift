//
//  PLNumberFormatter.swift
//  Santander

import Commons
import SANLegacyLibrary

final class PLNumberFormatter: AmountFormatterProvider {
    func formatterForRepresentation(_ amountRepresentation: AmountRepresentation) -> NumberFormatter? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.locale = Locale(identifier: "pl_PL")
        return numberFormatter
    }
}

extension PLNumberFormatter: CurrencyFormatterProvider {
    var defaultCurrency: CurrencyType {
        return .złoty
    }

    var decimalSeparator: Character {
        return ","
    }

    func assembleCurrencyString(for value: String, with symbol: String, representation: AmountRepresentation) -> CurrencySymbolPosition {
        return .rightPadded
    }
}
