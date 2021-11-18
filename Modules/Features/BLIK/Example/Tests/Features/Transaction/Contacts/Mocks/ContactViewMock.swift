@testable import BLIK
import UI

class ContactsViewMock: ContactsViewProtocol {

    var onSetupWithViewModel: (([ContactViewModel]) -> Void)?
    var showEmptyView = false
    var showLoaderCalled = false

    func setViewModels(_ viewModels: [ContactViewModel]) {
        onSetupWithViewModel?(viewModels)
    }
    
    func showEmptyView(_ show: Bool) {
        showEmptyView = show
    }
    
    func showLoader() {
        showLoaderCalled = true
    }
    
    func hideLoader(completion: (() -> Void)?) {
        completion?()
    }
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {}
    
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {}
    
    func showErrorMessage(title: String, message: String, actionButtonTitle: String, closeButton: Dialog.CloseButton, onConfirm: (() -> Void)?) {
    }
    
}
