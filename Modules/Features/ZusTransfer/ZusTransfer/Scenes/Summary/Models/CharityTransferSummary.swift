import Foundation
import SANLegacyLibrary
import SANPLLibrary

public struct ZusTransferSummary {
    let amount: Decimal
    let currency: CurrencyType
    let title: String
    let accountName: String
    let accountNumber: String
    let recipientName: String
    let dateString: String
    let transferType: AcceptDomesticTransactionParameters.TransferType?
}
