import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
@testable import ZusSMETransfer

extension AccountForDebit {
     static func stub(
         id: String = "1",
         name: String = "Konto Jakie Chcę",
         number: String = "26109000880000000142230553",
         availableFunds: Money = .init(amount: 1500, currency: "PLN"),
         defaultForPayments: Bool = false,
         type: AccountType = .PERSONAL,
         accountSequenceNumber: Int = 2,
         accountType: Int = -101,
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
