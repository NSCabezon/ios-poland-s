@testable import ZusSMETransfer

final class ZusSmeTransferSummaryCoordinatorMock: ZusSmeTransferSummaryCoordinatorProtocol {
    var goToMakeAnotherPaymentCalled = false
    var goToGlobalPositionCalled = false
    
    func goToMakeAnotherPayment() {
        goToMakeAnotherPaymentCalled = true
    }
    
    func goToGlobalPosition() {
        goToGlobalPositionCalled = true
    }
}
