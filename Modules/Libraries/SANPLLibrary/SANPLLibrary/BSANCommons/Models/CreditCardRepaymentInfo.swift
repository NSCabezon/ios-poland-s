import Foundation

public struct CreditCardRepaymentInfo: Codable {
    public var accountsForDebit: [CCRAccountDTO] = []
    public var accountsForCredit: [CCRAccountDTO] = []
    public var cards: [CCRCardDTO] = []
}
