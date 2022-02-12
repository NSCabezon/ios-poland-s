import PLCommons
@testable import ZusTransfer

struct ZusTransferFormViewModelMockBuilder {
    
    static func getZusTransferFormViewModel() -> ZusTransferFormViewModel {
        ZusTransferFormViewModel(
            recipient: "Zus",
            amount: 1,
            title: "sample",
            date: Date(),
            recipientAccountNumber: "59154010432197661408487467"
        )
    }
}
