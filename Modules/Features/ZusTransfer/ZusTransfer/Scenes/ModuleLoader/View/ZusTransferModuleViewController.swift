import Operative
import UI
import PLUI
import PLCommons
import CoreFoundationLib

protocol ZusTransferModuleViewProtocol: AnyObject,
                                        LoaderPresentable,
                                        ErrorPresentable {
}

final class ZusTransferModuleViewController: UIViewController {
    private let presenter: ZusTransferModulePresenterProtocol
    
    init(presenter: ZusTransferModulePresenterProtocol) {
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
            title: .title(key: localized("pl_zusTransfer_toolbar")))
            .build(on: self, with: nil
            )
        navigationController?.addNavigationBarShadow()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
}

extension ZusTransferModuleViewController: ZusTransferModuleViewProtocol {}
