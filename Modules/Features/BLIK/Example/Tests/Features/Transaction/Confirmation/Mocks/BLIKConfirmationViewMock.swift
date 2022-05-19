@testable import BLIK
import UI

final class BLIKConfirmationViewMock: UIViewController, BLIKConfirmationViewProtocol {
    
    var viewModel: BLIKTransactionViewModel?
    var updateCounterCalled = false
    var showLoaderCalled = false
    var hideLoaderCalled = false
    var startProgressAnimationCalled = false
    var totalDuration: TimeInterval = 0
    var remainingDuration: TimeInterval = 0
    
    func showDialog(_ dialog: LisboaDialog) {}
    
    func startProgressAnimation(totalDuration: TimeInterval, remainingDuration: TimeInterval) {
        startProgressAnimationCalled = true
        self.totalDuration = totalDuration
        self.remainingDuration = remainingDuration
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
