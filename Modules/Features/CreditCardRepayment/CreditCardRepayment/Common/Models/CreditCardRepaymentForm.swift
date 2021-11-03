import Foundation
import Models

struct CreditCardRepaymentForm {
    
    var creditCard: CCRCardEntity?
    var account: CCRAccountEntity?
    var repaymentType: CreditCardRepaymentType
    var amount: AmountEntity?
    var date: Date //TODO: Not sure if date should be represented as Date
    
    internal init(
        creditCard: CCRCardEntity?,
        account: CCRAccountEntity?,
        repaymentType: CreditCardRepaymentType,
        amount: AmountEntity?,
        date: Date
    ) {
        self.creditCard = creditCard
        self.account = account
        self.repaymentType = repaymentType
        self.amount = amount
        self.date = date
    }
    
    func replacing(creditCard: CCRCardEntity?) -> Self {
        Self(
            creditCard: creditCard,
            account: self.account,
            repaymentType: self.repaymentType,
            amount: self.amount,
            date: self.date
        )
    }
    
    func replacing(account: CCRAccountEntity?) -> Self {
        Self(
            creditCard: self.creditCard,
            account: account,
            repaymentType: self.repaymentType,
            amount: self.amount,
            date: self.date
        )
    }
    
    func replacing(repaymentType: CreditCardRepaymentType) -> Self {
        Self(
            creditCard: self.creditCard,
            account: self.account,
            repaymentType: repaymentType,
            amount: self.amount,
            date: self.date
        )
    }
    
    func replacing(amount: AmountEntity?) -> Self {
        Self(
            creditCard: self.creditCard,
            account: self.account,
            repaymentType: self.repaymentType,
            amount: amount,
            date: self.date
        )
    }
    
    func replacing(date: Date) -> Self {
        Self(
            creditCard: self.creditCard,
            account: self.account,
            repaymentType: self.repaymentType,
            amount: self.amount,
            date: date
        )
    }
}

extension CreditCardRepaymentForm: Equatable {
    static func == (lhs: CreditCardRepaymentForm, rhs: CreditCardRepaymentForm) -> Bool {        
        return lhs.creditCard == rhs.creditCard &&
            lhs.account == rhs.account &&
            lhs.repaymentType == rhs.repaymentType &&
            lhs.amount?.value == rhs.amount?.value &&
            lhs.amount?.currency == rhs.amount?.currency &&
            lhs.date == rhs.date
    }
}

extension CreditCardRepaymentForm: CustomStringConvertible {
    var description: String {
        get {
            "[" +
                "CreditCard: " + (creditCard?.description ?? "none") + " | " +
                "Account: " + (account?.description ?? "none") + " | " +
                "RepaymentType: " + repaymentType.localized + " | " +
                "Amount: " + (amount?.displayValueAndCurrency ?? "none") + " | " +
                "Date: " + date.toString(format: "dd.MM.YYYY") +
                "]"
        }
    }
}

private extension CCRCardEntity {
    var description: String {
        get {
            var desc = "(" + pan.trim()
            desc += " - " + alias
            return desc + ")"
        }
    }
}

private extension CCRAccountEntity {
    var description: String {
        get {
            var desc = "(" + number
            desc += " - " + alias
            return desc + ")"
        }
    }
}
