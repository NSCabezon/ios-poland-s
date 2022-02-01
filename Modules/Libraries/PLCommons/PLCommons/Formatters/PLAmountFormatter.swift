//
//  PLAmountFormatter.swift
//  PLCommons
//
//  Created by 187830 on 06/12/2021.
//

import Foundation
import CoreFoundationLib
import SANLegacyLibrary
import CoreFoundationLib

public struct PLAmountFormatter {
    
    public static func amountString(amount: Decimal, currency: CurrencyType, withAmountSize size: CGFloat) -> NSAttributedString {
        let moneyDecorator = MoneyDecorator(AmountEntity(value: amount, currency: currency),
                                            font: .santander(family: .text, type: .bold, size: size))
        let amount =  moneyDecorator.getFormatedCurrency() ?? NSAttributedString(string: "\(amount)")
        return amount
    }
}
