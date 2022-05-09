import UI
import PLUI
import IQKeyboardManagerSwift
import CoreFoundationLib
import IQKeyboardManagerSwift

protocol ZusSmeTransferFormViewProtocol: AnyObject,
                                         ConfirmationDialogPresentable,
                                         LoaderPresentable,
                                         ErrorPresentable {
    func updateRecipient(name: String, accountNumber: String, transactionTitle: String)
    func setAccountViewModel()
    func setVatAccountDetails(vatAccountDetails: VATAccountDetails)
    func showValidationMessages(with data: InvalidZusSmeTransferFormData)
    func showNotEnoughMoneyInfo(difference: Decimal, completion: @escaping () -> Void)
    func resetForm()
    func reloadAccountsComponent(with models: [SelectableAccountViewModel])
}

final class ZusSmeTransferFormViewController: UIViewController {
    private let presenter: ZusSmeTransferFormPresenterProtocol
    private let scrollView = UIScrollView()
    private let formView: ZusSmeTransferFormView
    private let bottomView = BottomButtonView(style: .red)
    
    init(presenter: ZusSmeTransferFormPresenterProtocol) {
        self.presenter = presenter
        self.formView = ZusSmeTransferFormView(language: presenter.getLanguage())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureKeyboardDismissGesture()
        IQKeyboardManager.shared.enableAutoToolbar = false
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.addNavigationBarShadow()
        IQKeyboardManager.shared.enableAutoToolbar = false
        view.layoutIfNeeded()
    }
}

private extension ZusSmeTransferFormViewController {
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func closeProcess() {
        presenter.didSelectCloseProcess()
    }
    
    func setUp() {
        addSubviews()
        configureView()
        prepareNavigationBar()
        setUpLayout()
        addKeyboardObserver()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(formView)
        view.addSubview(bottomView)
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .white,
            title: .title(key: localized("pl_zusTransfer_toolbar")
            )
        )
        .setLeftAction(.back(action: .closure(goBack)))
        .setRightActions(.close(action: .closure(closeProcess)))
        .build(on: self, with: nil)
    }
    
    func configureView() {
        view.backgroundColor = .white
        bottomView.configure(title: localized("pl_zusTransfer_button_doneTransfer")) { [weak self] in
            let form = self?.formView.getCurrentFormViewModel()
            self?.presenter.checkIfHaveEnoughFounds(transferAmount: form?.amount ?? 0, completion: { [weak self] in
                self?.presenter.showConfirmation()
            })
        }
        bottomView.disableButton()
        formView.configure(with: presenter.getSelectedAccountViewModels())
        formView.delegate = self
    }
    
    func setUpLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        formView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            formView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            formView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            formView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -16),
            formView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            bottomView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
        
    @objc func keyboardWillHide(notification: NSNotification) {
        //TODO: later
    }
}

extension ZusSmeTransferFormViewController: ZusSmeTransferFormViewProtocol {
    func setAccountViewModel() {
        formView.configure(with: presenter.getSelectedAccountViewModels())
    }
    
    func setVatAccountDetails(vatAccountDetails: VATAccountDetails) {
        formView.setVatAccountDetails(vatAccountDetails: vatAccountDetails)
    }
    
    func showValidationMessages(with data: InvalidZusSmeTransferFormData) {
        let form = formView.getCurrentFormViewModel()
        formView.showInvalidFormMessages(with: data)
        if data.shouldContinueButtonBeEnabled,
           form.amount != nil,
           form.recipientAccountNumber.count == presenter.getAccountRequiredLength() {
            bottomView.enableButton()
        } else {
            bottomView.disableButton()
        }
    }
    
    func showNotEnoughMoneyInfo(difference: Decimal, completion: @escaping () -> Void) {
        let numberForamtter = NumberFormatter.PLAmountNumberFormatter
        let formatedDifference = numberForamtter.string(for: difference) ?? ""
        InfoDialogBuilder(
            title: localized("generic_alert_information"),
            description: localized("pl_zusTransfer_text_notEnoughFounds", [StringPlaceholder(.value, formatedDifference)]),
            image: PLAssets.image(named: "info_black") ?? UIImage()
        ) {
            completion()
        }
        .build()
        .showIn(self)
    }
    
    func resetForm() {
        presenter.reloadAccounts()
        bottomView.disableButton()
        formView.clearForm()
        presenter.clearForm()
    }
    
    func reloadAccountsComponent(with models: [SelectableAccountViewModel]) {
        formView.configure(with: models)
    }
}

extension ZusSmeTransferFormViewController: ZusSmeTransferFormViewDelegate {

    func changeAccountTapped() {
        presenter.showAccountSelector()
    }
    
    func didChangeForm(with field: TransferFormCurrentActiveField) {
        presenter.updateTransferFormViewModel(
            with: formView.getCurrentFormViewModel()
        )
        presenter.startValidation(with: field)
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(
            x: 0,
            y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom
        )
        if (bottomOffset.y > 0) {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func didTapRecipientButton() {
        presenter.showRecipientSelection()
    }
    
    func updateRecipient(name: String, accountNumber: String, transactionTitle: String) {
        formView.updateRecipient(name: name, accountNumber: accountNumber, transactionTitle: transactionTitle)
    }
}
