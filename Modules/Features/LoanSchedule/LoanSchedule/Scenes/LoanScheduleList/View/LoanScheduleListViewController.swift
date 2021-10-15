import UI
import PLUI
import Commons
import Foundation

protocol LoanScheduleListViewProtocol: GenericErrorDialogPresentationCapable, LoadingViewPresentationCapable {
    func setUp(items: [LoanScheduleListItemViewModel])
    func setUp(information: LoanScheduleListInformationViewModel)
    func showError(closeAction: (() -> Void)?)
}

private enum Constants {
    static let backgroundColor = UIColor.white
}

final class LoanScheduleListViewController: UIViewController {
    private let presenter: LoanScheduleListPresenterProtocol
    private lazy var listView = LoanScheduleListView()
    private lazy var emptyView = PLEmptyView()
    private lazy var adapter = LoanScheduleListAdapter(tableView: listView.tableView)
    
    init(presenter: LoanScheduleListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_loanSchedule_title_loanSchedule")))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func setUpAdapter() {
        adapter.setUp()
    }
}

extension LoanScheduleListViewController: LoanScheduleListViewProtocol {
    func setUp(information: LoanScheduleListInformationViewModel) {
        listView.setTitle(information.title)
    }
    
    func setUp(items: [LoanScheduleListItemViewModel]) {
        if items.isEmpty {
            emptyView.setTitleText(localized("pl_loanSchedule_alert_noScheduleTitle"))
            emptyView.setMessageText(localized("pl_loanSchedule_alert_noSchedule"))
            view.replaceSuviewsToSingleSubview(emptyView)
        } else {
            view.replaceSuviewsToSingleSubview(listView)
            adapter.setUp(items: items)
        }
    }

    func showError(closeAction: (() -> Void)?) {
        showGenericErrorDialog(withDependenciesResolver: presenter.dependenciesResolver, closeAction: closeAction)
    }
}

private extension LoanScheduleListViewController {
    
    @objc func didSelectBack() {
        presenter.backButtonSelected()
    }
}

private extension UIView {
    func replaceSuviewsToSingleSubview(_ subview: UIView) {
        subviews.forEach { $0.removeFromSuperview() }
        addSubview(subview)
        subview.fillToSuperviewBounds()
    }
    
    func fillToSuperviewBounds() {
        guard let superview = superview else { fatalError("Superview can't be nill") }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
}
