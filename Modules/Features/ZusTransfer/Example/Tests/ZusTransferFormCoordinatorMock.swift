@testable import ZusTransfer

final class ZusTransferFormCoordinatorMock: ZusTransferFormCoordinatorProtocol {
    var showConfirmationCalled = false
    var showAccountSelectorCalled = false
    var closeProcessCalled = false
    var popCalled = false
    
    func pop() {
        popCalled = true
    }
    
    func closeProcess() {
        closeProcessCalled = true
    }
    
    func showAccountSelector(selectedAccountNumber: String) {
        showAccountSelectorCalled = true
    }
    
    func showConfiramtion(model: ZusTransferModel) {
        showConfirmationCalled = true
    }
}

