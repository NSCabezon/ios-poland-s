@testable import ZusTransfer

final class ZusTransferConfirmationCoordinatorMock: ZusTransferConfirmationCoordinatorProtocol {
    
    var showSummaryCalled = false
    var popCalled = false
    var backToTransferCalled = false

    func pop() {
        popCalled = true
    }
    
    func showSummary(with model: ZusTransferSummary) {
        showSummaryCalled = true
    }
    
    func backToTransfer() {
        backToTransferCalled = true
    }
}
