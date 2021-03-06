import Foundation
import SANLegacyLibrary
import SANPLLibrary

public struct MobileTransferSummary {
    public let amount: Decimal
    public let currency: CurrencyType
    public let title: String
    public let accountHolder: String
    public let accountName: String
    public let accountNumber: String
    public let recipientName: String
    public let recipientNumber: String
    public let dateString: String
    public let transferType: AcceptDomesticTransactionParameters.TransferType
}
