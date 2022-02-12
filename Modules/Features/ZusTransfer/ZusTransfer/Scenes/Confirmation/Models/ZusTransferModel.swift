
import PLUI
import PLCommons

public struct ZusTransferModel {
    public let amount: Decimal
    public let title: String?
    public let account: AccountForDebit
    public let recipientName: String?
    public let recipientAccountNumber: String
    public let transactionType: TransactionType
    public let date: Date?
}
