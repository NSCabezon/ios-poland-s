import Foundation

public struct CCRAccountDTO: Codable {
    
    public let number: String
    public let id: String
    public let taxAccountId: String?
    public let currencyCode: String
    public let name: AccountName?
    public let type: Type
    public let balance: Money
    public let availableFunds: Money
    public let lastUpdate: String?
    public let systemId: Int
    public let defaultForPayments: Bool
    public let role: Role?
    public let accountDetails: AccountDetails?
    public let creditCardAccountDetails: CreditCardAccountDetails?
}

public extension CCRAccountDTO {
    
    struct AccountName: Codable {
        public let source: String?
        public let description: String?
        public let userDefined: String?
    }
    
    enum `Type`: String, Codable {
        case AVISTA, SAVINGS, DEPOSIT, CREDIT_CARD, LOAN, INVESTMENT, VAT, SLINK, EFX, OTHER, PERSONAL
    }
    
    struct Money: Codable {
        public let value: Double
        public let currencyCode: String
    }
    
    enum Permissions: String, Codable {
        case READ, WRITE, SIGN, SEND
    }
    
    enum Role: String, Codable {
        case OWNER, CO_OWNER, WARRANTOR, PLENIPOTENTIARY
    }
    
    struct CreditCardAccountDetails: Codable {
        public let lastStatementDate: String?
        public let nextStatementDate: String?
        public let paymentDate: String?
        public let totalPaymentAmount: Money?
        public let minimalPaymentAmount: Money?
        public let interestForPreviousPeriod: Money?
        public let outstandingMinimumDueAmount: Money?
        public let currentMinimumDueAmount: Money?
        public let minimumRepaymentAmount: Money?
        public let totalRepaymentAmount: Money?
        public let creditLimit: Money?
    }
    
    struct AccountDetails: Codable {
        public let accountType: Int?
        public let sequenceNumber: Int
    }
}

public extension CCRAccountDTO {
    
    var alias: String? {
        get {
            guard let name = name else { return nil }
            if let properName = name.userDefined, !properName.isEmpty {
                return properName
            } else if let properName = name.source, !properName.isEmpty {
                return properName
            } else if let properName = name.description, !properName.isEmpty {
                return properName
            } else {
                return nil
            }
        }
    }
}
