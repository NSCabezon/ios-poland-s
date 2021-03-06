import Foundation
import SANPLLibrary

public struct Transaction {
    
    public let transactionId: Int
    public let title: String
    public let date: Date?
    public let time: Date?
    public let transferType: TransferType
    public let aliasContext: AliasContext
    public let amount: Decimal
    public let merchant: GetTrnToConfDTO.Merchant?
    public let transactionRawValue: GetTrnToConfDTO
    
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
    
    public enum AliasContext {
        case none
        case receivedAliasProposal(AliasProposal)
        case transactionWasPerformedWithAlias(Alias)
    }
    
    public struct AliasProposal {
        public let alias: String
        public let type: AliasProposalType
        public let label: String
    }
    
    public struct Alias {
        public let type: AliasType
        public let label: String
    }
    
    public enum AliasType {
        case uid
        case cookie
        case hce
        case md
    }
    
    // We support only these types of alias proposals on iOS
    public enum AliasProposalType: String {
        case uid
        case cookie
    }
}
