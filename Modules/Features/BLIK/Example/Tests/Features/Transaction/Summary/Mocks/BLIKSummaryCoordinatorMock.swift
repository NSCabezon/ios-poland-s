import Foundation
@testable import BLIK

final class BLIKSummaryCoordinatorMock: BLIKSummaryCoordinatorProtocol {
    var goToMakeAnotherPaymentCalled = false
    var goToGlobalPositionCalled = false
    var goToAliasRegistrationCalled = false
    
    func goToMakeAnotherPayment() {
        goToMakeAnotherPaymentCalled = true
    }
    
    func goToGlobalPosition() {
        goToGlobalPositionCalled = true
    }
    
    func goToAliasRegistration(with registerAliasInput: RegisterAliasInput) {
        goToAliasRegistrationCalled = true
    }
}
