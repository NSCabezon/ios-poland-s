import Foundation
import Commons
import SANLegacyLibrary
import Models

struct AmountFormatter {
    
    static func amountString(amount: Decimal, currency: CurrencyType, withAmountSize size: CGFloat) -> NSAttributedString {
        let moneyDecorator = MoneyDecorator(AmountEntity(value: amount, currency: currency),
                                            font: .santander(family: .text, type: .bold, size: size))
        
        let amount =  moneyDecorator.getFormatedCurrency() ?? NSAttributedString(string: "\(amount)")
        return amount
    }
}
