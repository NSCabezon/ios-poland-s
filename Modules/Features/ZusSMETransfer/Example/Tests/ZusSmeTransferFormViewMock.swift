import UI
import PLUI
@testable import ZusSMETransfer

final class ZusSmeTransferFormViewMock: ZusSmeTransferFormViewProtocol {
    var associatedLoadingView = UIViewController()
    var showDialogCalled = false
    var setAccountViewModelCalled = false
    var showValidationMessagesCalled = false
    var updateRecipientCalled = false
    var clearFormCalled = false
    var resetFormCalled = false
    var reloadAccountsComponentCalled = false
    var setVatAccountDetailsCalled = false
    var showNotEnoughMoneyInfoCalled = false
    
    func showDialog(_ dialog: LisboaDialog) {
        showDialogCalled = true
    }
    
    func setAccountViewModel() {
        setAccountViewModelCalled = true
    }
    
    func showValidationMessages(with data: InvalidZusSmeTransferFormData) {
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
    
    func setVatAccountDetails(vatAccountDetails: VATAccountDetails) {
        setVatAccountDetailsCalled = true
    }
    
    func showNotEnoughMoneyInfo(difference: Decimal, completion: @escaping () -> Void) {
        showNotEnoughMoneyInfoCalled = true
    }
    
    func showLoader() {}
    
    func hideLoader(completion: (() -> Void)?) {}
    
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {}
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {}
    
    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {}
    
    func showErrorMessage(title: String, message: String, image: String, onConfirm: (() -> Void)?) {}
    
    func showErrorMessage(title: String, message: String, actionButtonTitle: String, closeButton: Dialog.CloseButton, onConfirm: (() -> Void)?) {}
}
