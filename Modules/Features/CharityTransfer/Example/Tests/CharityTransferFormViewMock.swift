import UI
import PLUI
@testable import CharityTransfer

final class CharityTransferFormViewMock: CharityTransferFormViewProtocol {
    var associatedLoadingView = UIViewController()
    var showDialogCalled = false
    var setAccountViewModelCalled = false
    var showValidationMessagesCalled = false
    var updateRecipientCalled = false
    var clearFormCalled = false
    var resetFormCalled = false
    var reloadAccountsComponentCalled = false
    
    func showDialog(_ dialog: LisboaDialog) {
        showDialogCalled = true
    }
    
    func setAccountViewModel() {
        setAccountViewModelCalled = true
    }
    
    func showValidationMessages(messages: InvalidCharityTransferFormMessages) {
        showValidationMessagesCalled = true
    }
    
    func updateRecipient(name: String, accountNumber: String) {
        updateRecipientCalled = true
    }
    
    func clearForm() {
        clearFormCalled = true
    }
    
    func resetForm() {
        resetFormCalled = true
    }
    
    func reloadAccountsComponent(with models: [SelectableAccountViewModel]) {
        reloadAccountsComponentCalled = true
    }
    
    func showLoader() {}
    
    func hideLoader(completion: (() -> Void)?) {
        completion?()
    }
    
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {
        onConfirm?()
    }
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {
        onConfirm?()
    }
    
    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {
        onConfirm?()
    }
    
    func showErrorMessage(title: String, message: String, image: String, onConfirm: (() -> Void)?) {
        onConfirm?()
    }
    
    func showErrorMessage(title: String, message: String, actionButtonTitle: String, closeButton: Dialog.CloseButton, onConfirm: (() -> Void)?) {
        onConfirm?()
    }
}
