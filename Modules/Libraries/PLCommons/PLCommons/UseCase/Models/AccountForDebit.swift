
import Foundation

public struct AccountForDebit {
    public let id: String
    public let name: String
    public let number: String
    public let availableFunds: Money
    public let defaultForPayments: Bool
    public let type: AccountType
    public let accountSequenceNumber: Int
    public let accountType: Int
    
    public enum AccountType: String {
        case AVISTA, SAVINGS, DEPOSIT, CREDIT_CARD, LOAN, INVESTMENT, VAT, SLINK, EFX, OTHER, PERSONAL
    }
}

