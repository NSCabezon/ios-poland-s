
import Foundation

public struct AccountForDebit: Equatable {
    public let id: String
    public let name: String
    public let number: String
    public let availableFunds: Money
    public let defaultForPayments: Bool
    public let type: AccountType
    public let accountSequenceNumber: Int
    public let accountType: Int
    public let taxAccountNumber: String
    
    public init(id: String,
                name: String,
                number: String,
                availableFunds: Money,
                defaultForPayments: Bool,
                type: AccountType,
                accountSequenceNumber: Int,
                accountType: Int,
                taxAccountNumber: String) {
        self.id = id
        self.name = name
        self.number = number
        self.availableFunds = availableFunds
        self.defaultForPayments = defaultForPayments
        self.type = type
        self.accountSequenceNumber = accountSequenceNumber
        self.accountType = accountType
        self.taxAccountNumber = taxAccountNumber
    }
    
    public enum AccountType: String, Equatable {
        case AVISTA, SAVINGS, DEPOSIT, CREDIT_CARD, LOAN, INVESTMENT, VAT, SLINK, EFX, OTHER, PERSONAL
    }
}
