import CoreFoundationLib
import UI

protocol AuthorizationView: AnyObject {}

final class AuthorizationViewController: UIViewController {
    private let presenter: AuthorizationPresenterProtocol

    init(presenter: AuthorizationPresenterProtocol) {
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
}

extension AuthorizationViewController: AuthorizationView {
    // TODO: Add methods if needed (or remove protocol).
}

private extension AuthorizationViewController {
    func setUp() {
        configureNavigationItem()
    }
    
    func configureNavigationItem() {
        // TODO: Please update the navigation bar's localization key.
        NavigationBarBuilder(style: .white, title: .title(key: "#Mobilna_autoryzacja"))
            .setLeftAction(.back(action: #selector(back)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func back() {
        presenter.didTapBack()
    }
}
