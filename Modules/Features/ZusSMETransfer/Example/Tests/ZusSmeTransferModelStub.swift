import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
@testable import ZusSMETransfer

extension ZusSmeTransferModel {
    static func stub(
        amount: Decimal = 1500,
        title: String = "ZUS transfer",
        account: AccountForDebit = AccountForDebit.stub(),
        accountVat: VATAccountDetails = VATAccountDetails.stub(),
        recipientName: String = "ZUS",
        recipientAccountNumber: String = "82600000020260017772273629",
        transactionType: TransactionType = .zusTransfer,
        date: Date? = Date()
    ) -> ZusSmeTransferModel {
        ZusSmeTransferModel(
            amount: amount,
            title: title,
            account: account,
            accountVat: accountVat,
            recipientName: recipientName,
            recipientAccountNumber: recipientAccountNumber,
            transactionType: transactionType,
            date: date
        )
    }
}
