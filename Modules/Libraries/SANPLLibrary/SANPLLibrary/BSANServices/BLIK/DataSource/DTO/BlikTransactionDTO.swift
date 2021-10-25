public struct BlikTransactionDTO: Codable {
    public struct AmountDTO: Codable {
        public let amount: Decimal
        public let exRate: Decimal
        public let exDate: String
        public let cashback: Decimal
    }

    public struct MerchantDTO: Codable {
        public let name: String
        public let shortName: String
        public let address: String
        public let city: String
    }

    public struct AliasDTO: Codable {
        public struct ProposalDTO: Codable {
            public let alias: String?
            public let type: String?
        }
        
        public struct AuthDTO: Codable {
            public let type: String?
            public let label: String?
        }
        
        public let proposal: [ProposalDTO]
        public let auth: AuthDTO?
    }
    
    public let date: String
    public let time: String
    public let trnId: Int
    public let transferType: String
    public let title: String
    public let goods: String
    public let goodsUrl: String
    public let noConfLimitMax: Int
    public let maxChequeAmount: Int
    public let maxActiveCheques: Int
    public let amount: AmountDTO
    public let merchant: MerchantDTO
    public let aliases: AliasDTO?
}
