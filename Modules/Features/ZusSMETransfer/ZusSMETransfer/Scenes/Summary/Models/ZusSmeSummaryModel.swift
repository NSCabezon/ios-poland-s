import Foundation
import SANLegacyLibrary
import SANPLLibrary

struct ZusSmeSummaryModel {
    let amount: Decimal
    let currency: CurrencyType
    let title: String
    let accountName: String
    let accountNumber: String
    let accountVat: VATAccountDetails?
    let recipientName: String
    let recipientAccountNumber: String
    let dateString: String
    let transferType: AcceptDomesticTransactionParameters.TransferType?
}
