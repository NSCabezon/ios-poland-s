import Foundation
import CoreFoundationLib
import SANPLLibrary

struct CreditCardRepaymentSummary {
    
    let creditCard: CCRCardEntity
    let account: CCRAccountEntity
    let amount: AmountEntity
    let date: Date
    let transferType: String
    
    internal init(
        creditCard: CCRCardEntity,
        account: CCRAccountEntity,
        amount: AmountEntity,
        date: Date,
        transferType: String
    ) {
        self.creditCard = creditCard
        self.account = account
        self.amount = amount
        self.date = date
        self.transferType = transferType
    }
}
