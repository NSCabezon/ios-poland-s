import Commons
import CoreDomain
import PLCommons
import CoreFoundationLib
import SANPLLibrary
@testable import ZusTransfer

struct ZusTransferSummaryMockBuilder {
    static func getZusTransferSummaryMock() -> ZusTransferSummary {
        ZusTransferSummary(amount: 1500,
                           currency: .złoty,
                           title: "Przelew na ZUS",
                           accountName: "Konto Jakie Chcę",
                           accountNumber: "26109000880000000142230553",
                           recipientName: "ZUS",
                           dateString: "15.01.2022",
                           transferType: .ZUS)
    }
}
