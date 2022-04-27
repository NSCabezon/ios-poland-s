import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
@testable import ZusSMETransfer

extension ZusSmeSummaryModel {
    static func stub(
        amount: Decimal = 1,
        currency: CurrencyType = .złoty,
        title: String = "title",
        accountName: String = "accountName",
        accountNumber: String = "02600000020260006109165886",
        accountVat: VATAccountDetails? = VATAccountDetails.stub(),
        recipientName: String = "recipientName",
        recipientAccountNumber: String = "48191010482408000970680001",
        dateString: String = "15.01.2022",
        transferType: AcceptDomesticTransactionParameters.TransferType? = .ZUS
    ) -> ZusSmeSummaryModel {
        ZusSmeSummaryModel(
            amount: amount,
            currency: currency,
            title: title,
            accountName: accountName,
            accountNumber: accountNumber,
            accountVat: accountVat,
            recipientName: recipientName,
            recipientAccountNumber: recipientAccountNumber,
            dateString: dateString,
            transferType: AcceptDomesticTransactionParameters.TransferType.ZUS
        )
    }
}



