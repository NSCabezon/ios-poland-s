import Operative
import UI
import PLUI
import PLCommons
import CoreFoundationLib

protocol AuthorizationModuleViewProtocol: AnyObject, LoaderPresentable, ErrorPresentable { }

final class AuthorizationModuleViewController: UIViewController {
    private let presenter: AuthorizationModulePresenterProtocol
    
    init(presenter: AuthorizationModulePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatible with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
    
    private func setUp() {
        view.backgroundColor = .white
        prepareNavigationBar()
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .white,
            title: .title(key: localized("toolbar_title_mobileAuthorization")))
            .setLeftAction(.back(action: .closure(didSelectCloseProcess)))
            .setRightActions(.close(action: .closure(didSelectCloseProcess)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func didSelectCloseProcess() {
        presenter.didTapCloseProcess()
    }
}

extension AuthorizationModuleViewController: AuthorizationModuleViewProtocol {
    // TODO: Add methods if needed (or remove protocol).
}
