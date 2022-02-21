import UI
import PLUI
import PLCommons
import CoreFoundationLib

protocol CharityTransferModuleViewProtocol: AnyObject,
                                        LoaderPresentable,
                                        ErrorPresentable {
}

final class CharityTransferModuleViewController: UIViewController {
    private let presenter: CharityTransferModulePresenterProtocol
    
    init(presenter: CharityTransferModulePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
    
    private func setUp() {
        prepareNavigationBar()
        configureView()
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .white,
            title: .title(key: localized("pl_foundtrans_title_foundTransfer")))
            .build(on: self, with: nil
            )
        navigationController?.addNavigationBarShadow()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
}

extension CharityTransferModuleViewController: CharityTransferModuleViewProtocol {}
