@testable import CharityTransfer

final class CharityTransferConfirmationCoordinatorMock: CharityTransferConfirmationCoordinatorProtocol {
    
    var showSummaryCalled = false
    var popCalled = false
    var backToTransferCalled = false

    func pop() {
        popCalled = true
    }
    
    func showSummary(with model: CharityTransferSummary) {
        showSummaryCalled = true
    }
    
    func backToTransfer() {
        backToTransferCalled = true
    }
}

