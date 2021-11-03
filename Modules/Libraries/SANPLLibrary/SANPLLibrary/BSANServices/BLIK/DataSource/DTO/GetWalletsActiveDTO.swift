import Foundation

public struct GetWalletsActiveDTO: Decodable {
    public let ewId: Int
    public let chequePinStatus: ChequePinStatus
    public let alias: Alias
    public let accounts: Accounts
    public let noPinTrnVisible: Bool
    public let limits: LimitsInfo
}

extension GetWalletsActiveDTO {
    public enum ChequePinStatus: String, Codable {
        case notSet = "NOT_SET"
        case set = "SET"
        case blocked = "BLOCKED"
    }
    
    public struct Alias: Codable {
        public let label: String
        public let type: Type
        public let isSynced: Bool
        
        public enum `Type`: String, Codable {
            case empty = "EMPTY"
            case eWallet_Alias = "EWALLET_ALIAS"
            case eWalletAndPSP_Alias = "EWALLET_AND_PSP_ALIAS"
        }
    }
    
    public struct Accounts: Codable {
        public let srcAccName: String
        public let srcAccShortName: String
        public let srcAccNo: String
    }
    
    public struct LimitsInfo: Codable {
        public let noPinLimit: Decimal
        public let noConfLimit: Decimal
        public let shopLimits: Limit
        public let cashLimits: Limit
    }
    
    public struct Limit: Codable {
        public let trnLimit: Decimal
        public let cycleLimit: Decimal
        public let cycleLimitRemaining: Decimal
    }
}
