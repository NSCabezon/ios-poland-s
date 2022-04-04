import Operative
import UI
import PLUI
import PLCommons
import CoreFoundationLib

protocol SplitPaymentModuleViewProtocol: AnyObject,
                                        LoaderPresentable,
                                        ErrorPresentable {
}

final class SplitPaymentModuleViewController: UIViewController {
    private let presenter: SplitPaymentModulePresenterProtocol
    
    init(presenter: SplitPaymentModulePresenterProtocol) {
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
    
    #warning("pl_split_payment_toolbar should be localized")
    private func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .white,
            title: .title(key: localized("#pl_split_payment_toolbar")))
            .build(on: self, with: nil
            )
        navigationController?.addNavigationBarShadow()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
}

extension SplitPaymentModuleViewController: SplitPaymentModuleViewProtocol {}
