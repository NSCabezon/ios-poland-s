import PLUI
import PLCommons

struct ZusSmeTransferModel {
    let amount: Decimal
    let title: String?
    let account: AccountForDebit
    let accountVat: VATAccountDetails?
    let recipientName: String?
    let recipientAccountNumber: String
    let transactionType: TransactionType
    let date: Date?
}
