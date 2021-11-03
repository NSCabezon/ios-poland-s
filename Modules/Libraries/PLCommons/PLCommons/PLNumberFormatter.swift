//
//  PLNumberFormatter.swift
//  Santander

import Commons
import SANLegacyLibrary

public final class PLNumberFormatter: AmountFormatterProvider {
    public init() {}

    public func formatterForRepresentation(_ amountRepresentation: AmountRepresentation) -> NumberFormatter? {
        let fractionDigits = self.getFractionDigits(for: amountRepresentation)
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = " "
        numberFormatter.maximumFractionDigits = fractionDigits
        numberFormatter.minimumFractionDigits = fractionDigits
        numberFormatter.maximumIntegerDigits = 12
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "de")
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
        let formattedValue = self.getFormattedValue(for: value, with: representation)
        let formattedSymbol = self.getFormattedCurrency(for: symbol)
        return .custom(formattedString: "\(formattedValue) \(formattedSymbol)")
    }
}

private extension PLNumberFormatter {
    private func getFractionDigits(for amountRepresentation: AmountRepresentation) -> Int {
        switch amountRepresentation {
        case .with1M:
            return 3
        default:
            return 2
        }
    }

    private func getFormattedValue(for value: String, with representation: AmountRepresentation) -> String {
        return "\(value)\(self.isOneMillionFormat(representation) ? "M" : "")"
    }

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

    private func isOneMillionFormat(_ representation: AmountRepresentation) -> Bool {
        if case AmountRepresentation.with1M = representation {
            return true
        }
        return false
    }
}
