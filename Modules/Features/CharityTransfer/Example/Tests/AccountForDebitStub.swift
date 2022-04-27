import Foundation
import PLCommons

extension AccountForDebit {
    static func stub(
        id: String = "1",
        name: String = "Konto Jakie Chcesz",
        number: String = "12123412341234123412341234",
        availableFunds: Money = .init(amount: 1500, currency: "PLN"),
        defaultForPayments: Bool = false,
        type: AccountType = .PERSONAL,
        accountSequenceNumber: Int = 1,
        accountType: Int = 123,
        taxAccountNumber: String = "05109013620000000136623331"
    ) -> AccountForDebit {
        AccountForDebit(
            id: id,
            name: name,
            number: number,
            availableFunds: availableFunds,
            defaultForPayments: defaultForPayments,
            type: type,
            accountSequenceNumber: accountSequenceNumber,
            accountType: accountType,
            taxAccountNumber: taxAccountNumber
        )
    }
}
