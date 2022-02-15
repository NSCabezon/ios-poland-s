import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
@testable import CharityTransfer

struct CharityTransferSummaryMockBuilder {
    static func getCharityTransferSummaryMock() -> CharityTransferSummary {
        CharityTransferSummary(
            amount: 1,
            currency: .złoty,
            title: "Darowizna dla Fundacji Santander",
            accountName: "Konto Jakie Chcę",
            accountNumber: "26109000880000000142230553",
            recipientName: "Fundacja Santander",
            dateString: "16.12.2021",
            transferType: .INTERNAL
        )
    }
}
