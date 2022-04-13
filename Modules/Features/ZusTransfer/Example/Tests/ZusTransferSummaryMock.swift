import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
@testable import ZusTransfer

struct ZusTransferSummaryMock {
    static func getMock() -> ZusTransferSummary {
        ZusTransferSummary(
            amount: 1,
            currency: .złoty,
            title: "title",
            accountName: "accountName",
            accountNumber: "02600000020260006109165886",
            recipientName: "recipientName",
            recipientAccountNumber: "48191010482408000970680001",
            dateString: "15.01.2022",
            transferType: AcceptDomesticTransactionParameters.TransferType.ZUS
        )
    }
}
