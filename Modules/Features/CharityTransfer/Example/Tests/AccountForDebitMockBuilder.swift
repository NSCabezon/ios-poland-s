
import PLCommons
@testable import CharityTransfer

struct AccountForDebitMockBuilder {
    
    static func getAccountForDebitMockMock() -> [AccountForDebit] {
        return [AccountForDebit(id: "1234",
                                name: "Konto Jakie Chcesz",
                                number: "12123412341234123412341234",
                                availableFunds: .init(amount: 1500,
                                                      currency: "PLN"),
                                defaultForPayments: false,
                                type: .PERSONAL,
                                accountSequenceNumber: 1,
                                accountType: 123)]
    }
}
