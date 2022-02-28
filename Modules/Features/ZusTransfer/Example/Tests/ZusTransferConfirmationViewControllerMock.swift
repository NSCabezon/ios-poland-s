
import UI
@testable import ZusTransfer

final class ZusTransferConfirmationViewControllerMock: UIViewController, ZusTransferConfirmationViewControllerProtocol {
    var viewModel: ZusTransferConfirmationViewModel?
    var showDialogCalled = false
    var showLoaderCalled = false
    var hideLoaderCalled = false
    
    func setViewModel(_ viewModel: ZusTransferConfirmationViewModel) {
        self.viewModel = viewModel
    }
    
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {}
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {}
    
    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {}
    
    func showErrorMessage(title: String, message: String, image: String, onConfirm: (() -> Void)?) {}
    
    func showErrorMessage(title: String, message: String, actionButtonTitle: String, closeButton: Dialog.CloseButton, onConfirm: (() -> Void)?) {}
    
    func showLoader() {
        showLoaderCalled = true
    }
    
    func hideLoader(completion: (() -> Void)?) {
        hideLoaderCalled = true
    }
    
    func showDialog(_ dialog: LisboaDialog) {
        showDialogCalled = true
    }
}
