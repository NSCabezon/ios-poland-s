import UI
@testable import SplitPayment

final class RecipientSelectionViewControllerMock: UIViewController, RecipientSelectionViewProtocol {
    var setViewModelCalled = false
    var showDialogCalled = false
    var showLoaderCalled = false
    var hideLoaderCalled = false
    var showServiceInaccessibleMessageCalled = false
    var showErrorMessageCalled = false
    
    func setViewModel(_ viewModel: RecipientSelectionViewModel) {
        setViewModelCalled = true
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
    
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {
        showServiceInaccessibleMessageCalled = true
        onConfirm?()
    }
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {
        showErrorMessageCalled  = true
        onConfirm?()
    }
    
    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {
        onConfirm?()
    }
    
    func showErrorMessage(
        title: String,
        message: String,
        image: String,
        onConfirm: (() -> Void)?
    ) {
        onConfirm?()
    }

    func showErrorMessage(
        title: String,
        message: String,
        actionButtonTitle: String,
        closeButton: Dialog.CloseButton,
        onConfirm: (() -> Void)?
    ) {
        onConfirm?()
    }
}
