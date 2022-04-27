import UI
@testable import ZusSMETransfer

final class ZusSmeTransferConfirmationViewControllerMock: UIViewController, ZusSmeTransferConfirmationViewControllerProtocol {
    var viewModel: ZusSmeTransferConfirmationViewModel?
    var showDialogCalled = false
    var showLoaderCalled = false
    var hideLoaderCalled = false
    
    func setViewModel(_ viewModel: ZusSmeTransferConfirmationViewModel) {
        self.viewModel = viewModel
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
    
    func showLoader() {
        showLoaderCalled = true
    }
    
    func hideLoader(completion: (() -> Void)?) {
        hideLoaderCalled = true
        completion?()
    }
    
    func showDialog(_ dialog: LisboaDialog) {
        showDialogCalled = true
    }
}
