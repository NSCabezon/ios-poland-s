import Foundation
import SANLegacyLibrary
import SANPLLibrary

public struct CharityTransferSummary {
    let amount: Decimal
    let currency: CurrencyType
    let title: String
    let accountName: String
    let accountNumber: String
    let recipientName: String
    let dateString: String
    let transferType: AcceptDomesticTransactionParameters.TransferType?
}
