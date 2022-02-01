@testable import ZusTransfer

final class ZusTransferSummaryCoordinatorMock: ZusTransferSummaryCoordinatorProtocol {
    var goToMakeAnotherPaymentCalled = false
    var goToGlobalPositionCalled = false
    
    func goToMakeAnotherPayment() {
        goToMakeAnotherPaymentCalled = true
    }
    
    func goToGlobalPosition() {
        goToGlobalPositionCalled = true
    }
}
