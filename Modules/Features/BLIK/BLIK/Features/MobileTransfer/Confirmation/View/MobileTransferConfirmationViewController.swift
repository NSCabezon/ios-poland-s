import UI
import PLUI
import Commons
import Operative

protocol MobileTransferConfirmationViewControllerProtocol:
    ErrorPresentable,
    LoaderPresentable,
    ConfirmationDialogPresentable {
    func confirmTapped()
    func setViewModel(_ viewModel: MobileTransferViewModel)
}

final class MobileTransferConfirmationViewController: UIViewController {
    
    private let presenter: MobileTransferConfirmationPresenterProtocol
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let summaryView = OperativeSummaryStandardBodyView()
    private let footer = SummaryTotalAmountView()
    private let bottomView = BottomButtonView()
    
    init(presenter: MobileTransferConfirmationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
    
}

private extension MobileTransferConfirmationViewController {
    
    @objc func goBack() {
        presenter.goBack()
    }
    
    @objc func closeProcess() {
        presenter.closeProcess()
    }
    
    func setUp() {
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        setUpLayout()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(summaryView)
        stackView.addArrangedSubview(footer)
        view.addSubview(bottomView)
    }
    
    func prepareStyles() {
        view.backgroundColor = Const.Color.background
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 16, left: 0, bottom: 59, right: 0)
        
        bottomView.backgroundColor = .white
        bottomView.configure(title: localized("generic_button_confirm")) { [weak self] in
            self?.confirmTapped()
        }
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(style: .custom(background: .color(Const.Color.background),
                                            tintColor: .santanderRed),
                             title: .title(key: localized("genericToolbar_title_confirmation")))
            .setLeftAction(.back(action: #selector(goBack)))
            .setRightActions(.close(action: #selector(closeProcess)))
            .build(on: self, with: nil)
    }
    
    func setUpLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        footer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // temporary solution, change it when OperativeSummaryStandardBodyView's constraints are fixed
            footer.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: -46)
        ])
    }
}

extension MobileTransferConfirmationViewController: MobileTransferConfirmationViewControllerProtocol {
    
    func setViewModel(_ viewModel: MobileTransferViewModel) {
        let viewModelItems: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("summary_item_amount"),
                  subTitle: viewModel.amountString(withAmountSize: 32),
                  info: viewModel.title),
            .init(title: localized("pl_blik_label_accountTransfter"),
                  subTitle: viewModel.accountName,
                  info: viewModel.accountNumber),
            .init(title: localized("pl_blik_text_recipientTransfer"),
                  subTitle: viewModel.recipientName,
                  info: viewModel.phoneNumber),
            .init(title: localized("pl_blik_label_transType"),
                  subTitle: viewModel.transferType),
            .init(title: localized("pl_blik_label_date"),
                  subTitle: viewModel.dateString)]
        
        summaryView.setupWithItems(viewModelItems,
                                   actions: [],
                                   collapsableSections: .noCollapsable)
        footer.setAmount(viewModel.amountString(withAmountSize: 36))
    }
    
    func confirmTapped() {
        presenter.confirmTapped()
    }
}

extension MobileTransferConfirmationViewController {
    struct Const {
        struct Anchor {
            static let stackView: UIEdgeInsets = .init(top: 47, left: 16, bottom: -16, right: -16)
        }
        
        struct Color {
            static let background: UIColor = .skyGray
        }
    }
}
