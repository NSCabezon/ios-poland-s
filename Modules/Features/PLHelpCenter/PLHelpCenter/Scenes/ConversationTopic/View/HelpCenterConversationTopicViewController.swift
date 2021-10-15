
import UI
import Commons
import Foundation

protocol HelpCenterConversationTopicViewProtocol: GenericErrorDialogPresentationCapable, LoadingViewPresentationCapable {
    func setup(with viewModels: [HelpCenterSectionViewModel])
    func showErrorDialog()
}

final class HelpCenterConversationTopicViewController: UIViewController {
    var presenter: HelpCenterConversationTopicPresenterProtocol?
    private lazy var contentView = HelpCenterView()
    private lazy var adapter = HelpCenterAdapter(tableView: contentView.tableView)
    
    init(presenter: HelpCenterConversationTopicPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_helpdesk_title_contactSubject")))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
    }
}

extension HelpCenterConversationTopicViewController: HelpCenterConversationTopicViewProtocol {
    func setup(with viewModels: [HelpCenterSectionViewModel]) {
        adapter.setUp(with: viewModels)
    }
    
    func showErrorDialog() {
        let errorDialog = HelpCenterDialogFactory.makeErrorDialog()
        errorDialog.showIn(self)
    }
}

private extension HelpCenterConversationTopicViewController {
    
    @objc func didSelectBack() {
        presenter?.backButtonSelected()
    }

}
