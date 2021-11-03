@testable import BLIK
import UI

class MobileTransferFormViewMock: MobileTransferFormViewControllerProtocol {
    
    var showLoaderCalled = false
    
    func showDialog(_ dialog: LisboaDialog) {}
    
    func setAccountViewModel() {}
    
    func showValidationMessages(messages: InvalidTransferFormMessages) {}
    
    func fillWithContact(contact: Contact?) {}
    
    func showLoader() {
        showLoaderCalled = true
    }
    
    func hideLoader(completion: (() -> Void)?) {
        completion?()
    }
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {}
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {}
}
