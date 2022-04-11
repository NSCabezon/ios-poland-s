struct SplitPaymentFormViewModel {
    let recipient: String?
    let nip: String
    let grossAmount: Decimal
    let vatAmount: Decimal
    let invoiceTitle: String
    let title: String?
    let date: Date
    let recipientAccountNumber: String
}
