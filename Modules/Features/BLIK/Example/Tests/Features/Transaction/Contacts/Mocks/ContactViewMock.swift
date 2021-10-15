@testable import BLIK

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
    
    
}
