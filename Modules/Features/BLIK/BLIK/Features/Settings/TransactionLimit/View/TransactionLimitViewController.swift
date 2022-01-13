import UIKit
import UI
import PLUI
import Commons
import PLCommons

protocol TransactionLimitViewProtocol: LoaderPresentable, ErrorPresentable, SnackbarPresentable, DialogViewPresentationCapable {
    func setViewModel(viewModel: TransactionLimitViewModel)
    func showInvalidFormMessage(_ error: InvalidLimitFormMessages)
    func clearValidationMessages()
}

final class TransactionLimitViewController: UIViewController, TransactionLimitViewProtocol {
    private let presenter: TransactionLimitPresenterProtocol
    
    private let contentView = TransactionLimitView()
    private let footerView = TransactionLimitFooterView()
    
    init(
        presenter: TransactionLimitPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setUp()
    }
    
    func setViewModel(viewModel: TransactionLimitViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.contentView.set(viewModel: viewModel)
        }
    }
    
    func setIsSaveButtonEnabled(_ isEnabled: Bool) {
        footerView.setIsSaveButtonEnabled(isEnabled)
    }
    
    func showInvalidFormMessage(_ error: InvalidLimitFormMessages) {
        contentView.showInvalidFormMessage(error)
    }
    
    func clearValidationMessages() {
        contentView.clearValidationMessages()
    }
}

private extension TransactionLimitViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        configureTargets()
        configureDelegates()
        configureKeyboardDismissGesture()
    }
    
    func configureSubviews() {
        view.addSubview(contentView)
        view.addSubview(footerView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            footerView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureDelegates() {
        contentView.delegate = self
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_blik_title_limitTrans")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func configureTargets() {
        footerView.saveButtonTap = { [weak self] in
            guard let viewModel = TransactionLimitViewModel(
                withdrawLimitValue: self?.contentView.withdrawLimit ?? "",
                purchaseLimitValue: self?.contentView.purchaseLimit ?? ""
            ) else {
                return
            }
            
            self?.presenter.didPressSave(
                viewModel: viewModel
            )
        }
    }
    
    @objc func close() {
        guard let viewModel = TransactionLimitViewModel(
                withdrawLimitValue: contentView.withdrawLimit ?? "",
                purchaseLimitValue: contentView.purchaseLimit ?? ""
        ) else {
            return
        }
        
        presenter.didPressClose(
            viewModel: viewModel
        )
    }
}

extension TransactionLimitViewController: TransactionLimitViewDelegate {
    func didUpdateLimit() {
        guard let viewModel = TransactionLimitViewModel(
                withdrawLimitValue: contentView.withdrawLimit ?? "",
                purchaseLimitValue: contentView.purchaseLimit ?? ""
        ) else {
            return
        }
        
        presenter.didUpdateForm(viewModel: viewModel)
    }
}
