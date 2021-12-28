import Commons
import CoreDomain
import PLCommons
import CoreFoundationLib
import SANPLLibrary
@testable import CharityTransfer

struct CharityTransferModelMockBuilder {
    
    static func getCharityTransferModelMock() -> CharityTransferModel {
        let account = AccountForDebit(id: "142230553",
                                      name: "Konto Jakie Chcę",
                                      number: "26109000880000000142230553",
                                      availableFunds: Money(amount: 766.55, currency: "PLN"),
                                      defaultForPayments: false,
                                      type: .PERSONAL,
                                      accountSequenceNumber: 2,
                                      accountType: -101)
        return CharityTransferModel(amount: 1,
                                    title: "Darowizna dla Fundacji Santander",
                                    account: account,
                                    recipientName: "Fundacja Santander",
                                    recipientAccountNumber: "48191010482408000970680001",
                                    transactionType: .charityTransfer,
                                    date: Date())
    }
}
