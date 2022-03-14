import UI
@testable import ZusTransfer

final class ZusTransferFormViewMock: ZusTransferFormViewProtocol {
    var showDialogCalled = false
    var setAccountViewModelCalled = false
    var showValidationMessagesCalled = false
    var updateRecipientCalled = false
    var clearFormCalled = false
    
    func showDialog(_ dialog: LisboaDialog) {
        showDialogCalled = true
    }
    
    func setAccountViewModel() {
        setAccountViewModelCalled = true
    }
    
    func showValidationMessages(with data: InvalidZusTransferFormData) {
        showValidationMessagesCalled = true
    }
    
    func updateRecipient(name: String, accountNumber: String) {
        updateRecipientCalled = true
    }
    
    func clearForm() {
        clearFormCalled = true
    }
}
