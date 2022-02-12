import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
@testable import ZusTransfer

struct ZusTransferModelMockBuilder {
    
    static func getZusTransferModelMock() -> ZusTransferModel {
        let account = AccountForDebit(id: "142230553",
                                      name: "Konto Jakie Chcę",
                                      number: "26109000880000000142230553",
                                      availableFunds: Money(amount: 766.55, currency: "PLN"),
                                      defaultForPayments: false,
                                      type: .PERSONAL,
                                      accountSequenceNumber: 2,
                                      accountType: -101)
        return ZusTransferModel(amount: 1500,
                                title: "ZUS transfer",
                                account: account,
                                recipientName: "ZUS",
                                recipientAccountNumber: "82600000020260017772273629",
                                transactionType: .zusTransfer,
                                date: Date())
    }
}
