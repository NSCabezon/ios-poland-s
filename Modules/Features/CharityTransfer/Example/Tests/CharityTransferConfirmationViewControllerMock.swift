import UI
@testable import CharityTransfer

final class CharityTransferConfirmationViewControllerMock: CharityTransferConfirmationViewControllerProtocol {
    
    var viewModel: CharityTransferConfirmationViewModel?
    var showDialogCalled = false
    var showLoaderCalled = false
    var hideLoaderCalled = false
    
    func showDialog(_ dialog: LisboaDialog) {
        showDialogCalled = true
    }
    
    func showLoader() {
        showLoaderCalled = true
    }
    
    func hideLoader(completion: (() -> Void)?) {
        hideLoaderCalled = true
    }
    
    func setViewModel(_ viewModel: CharityTransferConfirmationViewModel) {
        self.viewModel = viewModel
    }
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {
    }
    
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {
    }
    
    func showErrorMessage(title: String, message: String, actionButtonTitle: String, closeButton: Dialog.CloseButton, onConfirm: (() -> Void)?) {
    }

    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {
    }
}
