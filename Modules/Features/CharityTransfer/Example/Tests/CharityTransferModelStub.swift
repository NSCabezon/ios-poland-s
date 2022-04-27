import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
@testable import CharityTransfer
import Foundation

extension CharityTransferModel {
    static func stub(
        amount: Decimal = 1,
        title: String = "Darowizna dla Fundacji Santander",
        recipientName: String = "Fundacja Santander",
        recipientAccountNumber: String = "48191010482408000970680001",
        transactionType: TransactionType = .charityTransfer,
        date: Date = Date()
    ) -> CharityTransferModel {
        let account = AccountForDebit.stub(
            id: "142230553",
            name: "Konto Jakie Chcę",
            number: "26109000880000000142230553",
            availableFunds: Money(amount: 766.55, currency: "PLN"),
            defaultForPayments: false,
            type: .PERSONAL,
            accountSequenceNumber: 2,
            accountType: -101,
            taxAccountNumber: "05109013620000000136623331"
        )
        return CharityTransferModel(
            amount: amount,
            title: title,
            account: account,
            recipientName: recipientName,
            recipientAccountNumber: recipientAccountNumber,
            transactionType: transactionType,
            date: date
        )
    }
}
