import Foundation

public struct TransactionLimitRequestDTO: Codable {
    public let shopLimits: Limits
    public let cashLimits: Limits
    
    public init(
        shopLimits: Limits,
        cashLimits: Limits
    ) {
        self.shopLimits = shopLimits
        self.cashLimits = cashLimits
    }
}

public extension TransactionLimitRequestDTO {
    struct Limits: Codable {
        public let trnLimit: Decimal
        public let cycleLimit: Decimal
        
        public init(
            trnLimit: Decimal,
            cycleLimit: Decimal
        ) {
            self.trnLimit = trnLimit
            self.cycleLimit = cycleLimit
        }
    }
}
