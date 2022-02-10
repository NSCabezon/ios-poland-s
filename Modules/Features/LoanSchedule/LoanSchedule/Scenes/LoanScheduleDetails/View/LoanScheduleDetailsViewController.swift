import UI
import CoreFoundationLib
import Foundation

protocol LoanScheduleDetailsViewProtocol: AnyObject {
    func setUp(withViewModel viewModel: LoanScheduleDetailsViewModel)
}

final class LoanScheduleDetailsViewController: UIViewController {
    private let presenter: LoanScheduleDetailsPresenterProtocol
    private lazy var contentView = LoanScheduleDetailsView()
    
    init(presenter: LoanScheduleDetailsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_loanSchedule_title_details")))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
}

extension LoanScheduleDetailsViewController: LoanScheduleDetailsViewProtocol {
    func setUp(withViewModel viewModel: LoanScheduleDetailsViewModel) {
        contentView.setUp(withViewModel: viewModel)
    }
}

private extension LoanScheduleDetailsViewController {
    
    @objc func didSelectBack() {
        presenter.backButtonSelected()
    }
}
