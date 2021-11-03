//
//  PLAmountNumberFormatter.swift
//  PLUI
//
//  Created by Piotr Mielcarzewicz on 19/07/2021.
//

import Foundation

public extension NumberFormatter {
    static var PLAmountNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.alwaysShowsDecimalSeparator = false
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 2
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.groupingSize = 3
        formatter.roundingMode = .down
        return formatter
    }
    
    static var PLAmountNumberFormatterWithoutCurrency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = false
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 2
        formatter.maximumIntegerDigits = 12
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.groupingSize = 3
        formatter.roundingMode = .down
        return formatter
    }
}
