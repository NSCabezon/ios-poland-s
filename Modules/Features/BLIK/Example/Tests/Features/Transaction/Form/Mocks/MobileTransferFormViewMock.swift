import UI
import PLCommons
@testable import BLIK

final class MobileTransferFormViewMock: UIViewController, MobileTransferFormViewControllerProtocol {
  
    var showLoaderCalled = false
    
    func showDialog(_ dialog: LisboaDialog) {}
    
    func setAccountViewModel() {}
    
    func showValidationMessages(messages: InvalidMobileTransferFormMessages) {}
    
    func fillWithContact(contact: MobileContact?) {}
    
    func showLoader() {
        showLoaderCalled = true
    }
    
    func hideLoader(completion: (() -> Void)?) {
        completion?()
    }
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {}
    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {}
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {}
    func showErrorMessage(title: String, message: String, actionButtonTitle: String, closeButton: Dialog.CloseButton, onConfirm: (() -> Void)?) {
    }
}
