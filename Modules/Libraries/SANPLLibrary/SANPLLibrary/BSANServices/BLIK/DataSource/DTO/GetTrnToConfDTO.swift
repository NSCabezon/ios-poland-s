import Foundation
import SANLegacyLibrary

public struct GetTrnToConfDTO: Decodable {
    public let trnId: Int
    public let title: String
    public let date: String
    public let time: String
    public let transferType: TransferType
    public let merchant: Merchant?
    public let amount: Amount
    public let aliases: AliasData
    
    public struct Merchant: Decodable {
        public let shortName: String?
        public let address: String?
        public let city: String?
    }
    
    public struct Amount: Decodable {
        public let amount: Double
    }
    
    public enum TransferType: String, Decodable {
        case blikPurchases = "BLIK_PURCHASES"
        case blikCashback = "BLIK_CASHBACK"
        case blikAtmWithdrawal = "BLIK_ATM_WITHDRAWAL"
        case blikCashAdvance = "BLIK_CASH_ADVANCE"
        case blikWebPurchases = "BLIK_WEB_PURCHASES"
        case blikPosRefund = "BLIK_POS_REFUND"
        case blikWebRefund = "BLIK_WEB_REFUND"
        case blikAtmWithdrawalPsp = "BLIK_ATM_WITHDRAWAL_PSP"
    }
    
    public struct AliasData: Decodable {
        public let proposal: [AliasProposal]
        public let auth: [AliasAuth]
    }
    
    public struct AliasProposal: Decodable {
        public let alias: String
        public let type: AliasType
        public let label: String
    }
    
    public struct AliasAuth: Decodable {
        public let type: AliasType
        public let label: String
    }
    
    public enum AliasType: String, Decodable {
        case md = "MD"
        case uid = "UID"
        case cookie = "COOKIE"
        case hce = "HCE"
    }
}
