public struct DebitAccountDTO: Codable {
    public let number: String
    public let id: String
    public let currencyCode: String
    public let name: Name
    public let type: String
    public let balance: Amount
    public let availableFunds: Amount
    public let systemId: Int
    public let defaultForPayments: Bool
    public let accountDetails: AccountDetails
    public let taxAccountNumber: String?
    
    public struct Name: Codable {
        public let source: String
        public let description: String
        public let userDefined: String
    }
    
    public struct Amount: Codable {
        public let value: Decimal
        public let currencyCode: String
    }
    
    public struct AccountDetails: Codable {
        public let accountType: Int
        public let sequenceNumber: Int
    }
}
