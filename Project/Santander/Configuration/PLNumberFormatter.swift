//
//  PLNumberFormatter.swift
//  Santander

import Commons
import SANLegacyLibrary

final class PLNumberFormatter: AmountFormatterProvider {
    func formatterForRepresentation(_ amountRepresentation: AmountRepresentation) -> NumberFormatter? {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = " "
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumIntegerDigits = 12
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "de")
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
        let formattedSymbol = self.getFormattedCurrency(for: symbol)
        return .custom(formattedString: "\(value) \(formattedSymbol)")
    }
}

private extension PLNumberFormatter {
    private func getFormattedCurrency(for symbol: String) -> String {
        switch symbol {
        case "€":
            return "EUR"
        case "$":
            return "USD"
        case "£":
            return "GBP"
        case "PLN":
            return "PLN"
        default:
            return symbol.uppercased()
        }
    }
}
