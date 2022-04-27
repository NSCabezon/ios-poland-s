import PLCommons
@testable import CharityTransfer

struct CharityTransferFormViewModelBuilderMock {
    static func getCharityTransferFormViewModel() -> CharityTransferFormViewModel {
        CharityTransferFormViewModel(
            amount: 2,
            date: Date(),
            recipientAccountNumberUnformatted: "26109000880000000142230553"
        )
    }
}
