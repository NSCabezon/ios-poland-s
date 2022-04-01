
import PLUI
import PLCommons

struct SplitPaymentModel {
    public let transactionType: TransactionType = .splitPayment
    public let account: AccountForDebit
    public let recipientName: String?
    public let recipientAccountNumber: String
    public let nipNumber: String
    public let grossAmount: Decimal
    public let vatAmount: Decimal
    public let invoiceTitle: String
    public let title: String?
    public let date: Date?
}
