import Foundation

public struct Transaction {
    
    public let transactionId: Int
    public let title: String
    public let date: Date?
    public let time: Date?
    public let transferType: TransferType
    public let placeName: String?
    public let address: String?
    public let city: String?
    public let amount: Double
    
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
}