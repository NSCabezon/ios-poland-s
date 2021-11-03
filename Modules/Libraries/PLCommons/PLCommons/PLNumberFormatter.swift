//
//  PLNumberFormatter.swift
//  Santander

import Commons
import SANLegacyLibrary

public final class PLNumberFormatter: AmountFormatterProvider {
    public init() {}

    public func formatterForRepresentation(_ amountRepresentation: AmountRepresentation) -> NumberFormatter? {
        switch amountRepresentation {
        case .amountTextField(maximumFractionDigits: let maximumFractionDigits, maximumIntegerDigits: let maximumIntegerDigits):
            return self.generateAmountTextField(maximumFractionDigits: maximumFractionDigits, maximumIntegerDigits: maximumIntegerDigits)
        case .withoutDecimals:
            return self.generateWithoutDecimals()
        case .with1M:
            return self.generateWith1M()
        case .decimal(decimals: let decimals):
            return self.generateDecimals(decimals)
        case .decimalTracker(decimals: let decimals):
            return self.generateDecimalTracker(decimals)
        case .decimalServiceValue(decimals: let decimals):
            return self.generateDecimalServiceValue(decimals)
        case .decimalSmart(decimals: let decimals):
            return self.generateDecimalSmart(decimals)
        case .descriptionPFM(decimals: let decimals):
            return self.generateDescriptionPFM(decimals)
        case .description(decimals: let decimals):
            return self.generateDescription(decimals)
        case .wholePart:
            return self.generateWholePart()
        case .tae(decimals: let decimals):
            return self.generateTae(decimals)
        case .sharesCount5Decimals:
            return self.generateSharesCount5Decimals()
        case .transactionFilters:
            return self.generateTransactionFilters()
        case .withSeparator(decimals: let decimals):
            return self.generateWithSeparator(decimals)
        case .default:
            return NumberFormatter()
        }
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

    private func generateWithoutDecimals() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de")
        return formatter
    }

    private func generateWith1M() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 3
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de")
        return formatter
    }

    private func generateDecimals(_ decimals: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de")
        return formatter
    }

    private func generateDecimalTracker(_ decimals: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de")
        return formatter
    }

    private func generateDecimalServiceValue(_ decimals: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de")
        return formatter
    }

    private func generateDecimalSmart(_ decimals: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = 0
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de")
        return formatter
    }

    private func generateDescriptionPFM(_ decimals: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        return formatter
    }

    private func generateDescription(_ decimals: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de")
        return formatter
    }

    private func generateWholePart() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 10
        formatter.minimumFractionDigits = 10
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de")
        return formatter
    }

    private func generateTae(_ decimals: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        var positiveFormat = "#,##0."
        for _ in 0 ..< decimals {
            positiveFormat.append("0")
        }
        formatter.positiveFormat = positiveFormat
        formatter.negativeFormat = formatter.positiveFormat
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = " "
        return formatter
    }

    private func generateSharesCount5Decimals() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 5
        formatter.minimumFractionDigits = 5
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        return formatter
    }

    private func generateTransactionFilters() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = false
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 2
        formatter.maximumIntegerDigits = 6
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.groupingSize = 3
        formatter.roundingMode = .down
        return formatter
    }

    private func generateWithSeparator(_ decimals: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        return formatter
    }

    private func generateAmountTextField(maximumFractionDigits: Int, maximumIntegerDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = false
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.maximumIntegerDigits = maximumIntegerDigits
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.groupingSize = 3
        formatter.roundingMode = .down
        formatter.locale = Locale(identifier: "de")
        return formatter
    }
}
