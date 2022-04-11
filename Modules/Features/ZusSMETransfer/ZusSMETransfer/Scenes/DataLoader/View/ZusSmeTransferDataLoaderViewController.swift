import Operative
import UI
import PLUI
import PLCommons
import CoreFoundationLib

protocol ZusSmeTransferDataLoaderViewProtocol: AnyObject,
                                        LoaderPresentable,
                                        ErrorPresentable {
    func showEmptyAccountsDialog(title: LocalizedStylableText, description: LocalizedStylableText)
}

final class ZusSmeTransferDataLoaderViewController: UIViewController {
    private let presenter: ZusSmeTransferDataLoaderPresenterProtocol
    
    init(presenter: ZusSmeTransferDataLoaderPresenterProtocol) {
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

extension ZusSmeTransferDataLoaderViewController: ZusSmeTransferDataLoaderViewProtocol {
    func showEmptyAccountsDialog(title: LocalizedStylableText, description: LocalizedStylableText) {
        InfoDialogBuilder(
            title: title,
            description: description,
            image: PLAssets.image(named: "info_black") ?? UIImage()
        ) { [weak self] in
            self?.presenter.close()
        }
        .build()
        .showIn(self)
    }
}
