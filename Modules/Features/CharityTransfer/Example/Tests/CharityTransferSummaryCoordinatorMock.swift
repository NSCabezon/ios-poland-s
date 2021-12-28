@testable import CharityTransfer

final class CharityTransferSummaryCoordinatorMock: CharityTransferSummaryCoordinatorProtocol {
    var goToMakeAnotherPaymentCalled = false
    var goToGlobalPositionCalled = false
    
    func goToMakeAnotherPayment() {
        goToMakeAnotherPaymentCalled = true
    }
    
    func goToGlobalPosition() {
        goToGlobalPositionCalled = true
    }
}
