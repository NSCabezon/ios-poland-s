import UI
@testable import ZusTransfer

final class ZusTransferFormViewMock: ZusTransferFormViewProtocol {
    var showDialogCalled = false
    var setAccountViewModelCalled = false
    var showValidationMessagesCalled = false
    
    func showDialog(_ dialog: LisboaDialog) {
        showDialogCalled = true
    }
    
    func setAccountViewModel() {
        setAccountViewModelCalled = true
    }
    
    func showValidationMessages(with data: InvalidZusTransferFormData) {
        showValidationMessagesCalled = true
    }
}
