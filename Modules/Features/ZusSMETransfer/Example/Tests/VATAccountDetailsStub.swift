import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
@testable import ZusSMETransfer

extension VATAccountDetails {
    static func stub(
        number: String = "05109013620000000136623331",
        name: String = "VAT",
        availableFunds: Decimal = 1000,
        currency: String = "PLN"
    ) -> VATAccountDetails {
        VATAccountDetails(
            number: "05109013620000000136623331",
            name: "VAT",
            availableFunds: 1000,
            currency: "PLN"
        )
    }
}
