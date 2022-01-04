@testable import BLIK
import UI

class BLIKConfirmationViewMock: BLIKConfirmationViewProtocol {
    
    var viewModel: BLIKTransactionViewModel?
    var updateCounterCalled = false
    var showLoaderCalled = false
    var hideLoaderCalled = false
    
    func showDialog(_ dialog: LisboaDialog) {}
    
    func startProgressAnimation(totalDuration: TimeInterval, remainingDuration: TimeInterval) {
        
    }
    
    func updateCounter(remainingSeconds: Int) {
        updateCounterCalled = true
    }
    
    func showLoader() {
        showLoaderCalled = true
    }
    
    func hideLoader(completion: (() -> Void)?) {
        hideLoaderCalled = true
        completion?()
    }
    
    func setViewModel(_ viewModel: BLIKTransactionViewModel) {
        self.viewModel = viewModel
    }
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {
    }
    
    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {
    }
    
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {
    }
    
    func showErrorMessage(title: String, message: String, actionButtonTitle: String, closeButton: Dialog.CloseButton, onConfirm: (() -> Void)?) {
    }
}
