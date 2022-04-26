@testable import ZusSMETransfer

final class ZusSmeTransferConfirmationCoordinatorMock: ZusSmeTransferConfirmationCoordinatorProtocol {
    var showSummaryCalled = false
    var popCalled = false
    var backToTransferCalled = false

    func pop() {
        popCalled = true
    }
    
    func showSummary(with model: ZusSmeSummaryModel) {
        showSummaryCalled = true
    }
    
    func backToTransfer() {
        backToTransferCalled = true
    }
}
