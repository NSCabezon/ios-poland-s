//
//  PLAmountFormatter.swift
//  PLCommons
//
//  Created by 187830 on 06/12/2021.
//

import Foundation
import CoreFoundationLib
import SANLegacyLibrary

public struct PLAmountFormatter {
    
    public static func amountString(amount: Decimal, currency: CurrencyType, withAmountSize size: CGFloat) -> NSAttributedString {
        let moneyDecorator = MoneyDecorator(AmountEntity(value: amount, currency: currency),
                                            font: .santander(family: .text, type: .bold, size: size))
        let amount =  moneyDecorator.getFormatedCurrency() ?? NSAttributedString(string: "\(amount)")
        return amount
    }
    
    public static func formatAmount(amount: String,
                                    maximumFractionDigits: Int = 2,
                                    maximumIntegerDigits: Int = 12,
                                    minimumIntegerDigits: Int = 1,
                                    minimumFractionDigits: Int = 2,
                                    groupingSize: Int = 3) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = false
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.maximumIntegerDigits = maximumIntegerDigits
        formatter.minimumIntegerDigits = minimumIntegerDigits
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.groupingSize = groupingSize
        formatter.roundingMode = .down
        formatter.locale = Locale(identifier: "en")
        var newText = amount.replacingOccurrences(of: ".", with: ",")
        newText = amount.replacingOccurrences(of: " ", with: "")
        guard let decimalValue = Decimal(string: newText),
              let formattedText = formatter.string(from: NSDecimalNumber(decimal: decimalValue))
        else {
            return nil
        }
        
        return formattedText
    }
}
