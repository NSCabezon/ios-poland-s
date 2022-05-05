import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
@testable import ZusSMETransfer

struct ZusSmeTransferSummaryStubBuilder {
    static func getZusSmeTransferSummaryStub() -> ZusSmeSummaryModel {
        ZusSmeSummaryModel(amount: 1500,
                           currency: .złoty,
                           title: "Przelew na ZUS",
                           accountName: "Konto Jakie Chcę",
                           accountNumber: "26109000880000000142230553",
                           accountVat: VATAccountDetails.stub(),
                           recipientName: "ZUS",
                           recipientAccountNumber: "02600000020260006109165886",
                           dateString: "15.01.2022",
                           transferType: .ZUS)
    }
}
