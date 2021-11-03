import Foundation
import Commons
import SANLegacyLibrary
import Models

struct AmountFormatter {
    
    static func amountString(amount: Double, currency: CurrencyType, withAmountSize size: CGFloat) -> NSAttributedString {
        let moneyDecorator = MoneyDecorator(AmountEntity(value: Decimal(amount), currency: currency),
                                            font: .santander(family: .text, type: .bold, size: size))
        
        let amount =  moneyDecorator.getFormatedCurrency() ?? NSAttributedString(string: "\(amount)")
        return amount
    }
}
