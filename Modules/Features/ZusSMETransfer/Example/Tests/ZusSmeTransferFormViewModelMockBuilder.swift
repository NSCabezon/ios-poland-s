import PLCommons
@testable import ZusSMETransfer

struct ZusSmeTransferFormViewModelMockBuilder {
    
    static func getZusSmeTransferFormViewModel() -> ZusSmeTransferFormViewModel {
        ZusSmeTransferFormViewModel(
            recipient: "Zus",
            amount: 1,
            title: "sample",
            date: Date(),
            recipientAccountNumber: "59154010432197661408487467"
        )
    }
}
