
@testable import CharityTransfer

final class CharityTransferFormCoordinatorMock: CharityTransferFormCoordinatorProtocol {
    
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
    
    func showConfirmation(with model: CharityTransferModel) {
        showConfirmationCalled = true
    }

}
