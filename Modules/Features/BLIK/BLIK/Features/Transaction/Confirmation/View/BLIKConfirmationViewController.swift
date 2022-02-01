import UI
import CoreFoundationLib
import PLCommons
import Foundation
import Operative
import CoreFoundationLib
import PLUI

protocol BLIKConfirmationViewProtocol: AnyObject, ErrorPresentable, LoaderPresentable, ConfirmationDialogPresentable {
    func startProgressAnimation(totalDuration: TimeInterval, remainingDuration: TimeInterval)
    func updateCounter(remainingSeconds: Int)
    func setViewModel(_ viewModel: BLIKTransactionViewModel)
}

final class BLIKConfirmationViewController: UIViewController {
    private let presenter: BLIKConfirmationPresenterProtocol
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let aliasInfoBanner = BLIKConfirmationAliasInfoBannerView()
    private let bottomView = BottomButtonView()
    private let progressView = BLIKConfirmationProgressView()
    private let summaryView = OperativeSummaryStandardBodyView()
    private let footer = SummaryTotalAmountView()
    
    private lazy var aliasInfoBannerZeroHeightConstraint = aliasInfoBanner.heightAnchor.constraint(equalToConstant: 0)

    init(presenter: BLIKConfirmationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }
}

extension BLIKConfirmationViewController: BLIKConfirmationViewProtocol {
    func startProgressAnimation(totalDuration: TimeInterval, remainingDuration: TimeInterval) {
        progressView.startProgressBarAnimation(totalDuration: totalDuration, remainingDuration: remainingDuration)
    }
    
    func updateCounter(remainingSeconds: Int) {
        progressView.setRemainingSeconds(remainingSeconds)
    }
    
    func setViewModel(_ viewModel: BLIKTransactionViewModel) {

        var viewModelItems: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("summary_item_amount"),
                  subTitle: viewModel.amountString(withAmountSize: 32),
                  info: viewModel.title,
                  accessibilityIdentifier: AccessibilityBLIK.ConfirmationOperativeSummary.itemAmount.id),
            .init(title: localized("pl_blik_label_transType"),
                  subTitle: viewModel.transferTypeString,
                  accessibilityIdentifier: AccessibilityBLIK.ConfirmationOperativeSummary.itemTransferType.id)
        ]
        
        if let address = viewModel.address, !address.isEmpty {
            viewModelItems.append(
                .init(title: localized("pl_blik_label_place"),
                      subTitle: address,
                      accessibilityIdentifier: AccessibilityBLIK.ConfirmationOperativeSummary.itemAddress.id)
            )
        }
        
        viewModelItems.append(.init(title: localized("pl_blik_label_date"),
                                    subTitle: viewModel.dateString,
                                    accessibilityIdentifier: AccessibilityBLIK.ConfirmationOperativeSummary.itemDate.id))
        
        if let aliasLabel = viewModel.aliasLabelUsedInTransaction {
            viewModelItems.append(
                .init(title: localized("pl_blik_text_withoutCode"),
                      subTitle: aliasLabel,
                      accessibilityIdentifier: AccessibilityBLIK.ConfirmationOperativeSummary.aliasLabel.id)
            )
        }
        
        summaryView.setupWithItems(viewModelItems, actions: [], collapsableSections: .noCollapsable)
        
        footer.setAmount(viewModel.amountString(withAmountSize: 36))
        
        if viewModel.shouldShowAliasTransferInfoBanner {
            aliasInfoBannerZeroHeightConstraint.isActive = false
        } else {
            aliasInfoBannerZeroHeightConstraint.isActive = true
        }
        
        progressView.isHidden = false
        scrollView.isHidden = false
        aliasInfoBanner.isHidden = false
    }
}

private extension BLIKConfirmationViewController {
    @objc func didSelectClose() {
        presenter.didSelectClose()
    }
    
    @objc func didSelectBack() {
        presenter.didSelectBack()
    }
    
    func setup() {
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        prepareLayout()
        summaryView.accessibilityIdentifier = AccessibilityBLIK.ConfirmationOperativeSummary.root.id
    }

    func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .custom(background: .color(.skyGray), tintColor: .santanderRed),
            title: .title(key: localized("genericToolbar_title_confirmation"))
        )
        .setLeftAction(.back(action: #selector(didSelectBack)))
        .setRightActions(.close(action: #selector(didSelectClose)))
        .build(on: self, with: nil)
    }
    
    func addSubviews() {
        view.addSubview(progressView)
        view.addSubview(scrollView)
        view.addSubview(aliasInfoBanner)
        view.addSubview(bottomView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(summaryView)
        stackView.addArrangedSubview(footer)
    }
    
    func prepareStyles() {
        view.backgroundColor = .skyGray
        bottomView.backgroundColor = .white
        
        progressView.isHidden = true
        scrollView.isHidden = true
        aliasInfoBanner.isHidden = true
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 16, left: 0, bottom: 59, right: 0)
        
        bottomView.configure(title: localized("generic_button_confirm")) { [weak self] in
            self?.presenter.didSelectConfirm()
        }
    }
    
    func prepareLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        aliasInfoBanner.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        footer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            aliasInfoBanner.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            aliasInfoBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            aliasInfoBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomView.topAnchor.constraint(equalTo: aliasInfoBanner.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            // temporary solution, change it when OperativeSummaryStandardBodyView's constraints are fixed
            footer.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: -46)
        ])
    }
}
