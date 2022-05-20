@testable import ZusTransfer

final class ZusTransferSummaryCoordinatorMock: ZusTransferSummaryCoordinatorProtocol {
    var goToMakeAnotherPaymentCalled = false
    var backToTransfersCalled = false
    
    func goToMakeAnotherPayment() {
        goToMakeAnotherPaymentCalled = true
    }
    
    func backToTransfers() {
        backToTransfersCalled = true
    }
}
