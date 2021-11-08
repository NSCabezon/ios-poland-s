@testable import PLHelpCenter

final class HelpCenterConversationTopicViewMock: HelpCenterConversationTopicViewProtocol {
    var associatedGenericErrorDialogView = UIViewController()
    var associatedLoadingView = UIViewController()
    
    var onShowError: (() -> Void)?
    
    private(set) var didSetupWithModelsCalled: Bool = false
    private(set) var willShowErrorDialogCalled: Bool = false
    
    private(set) var viewModels: [HelpCenterSectionViewModel] = []
    
    func setup(with viewModels: [HelpCenterSectionViewModel]) {
        self.viewModels = viewModels
        didSetupWithModelsCalled = true
    }
    
    func showErrorDialog() {
        willShowErrorDialogCalled = true
        onShowError?()
    }
}
