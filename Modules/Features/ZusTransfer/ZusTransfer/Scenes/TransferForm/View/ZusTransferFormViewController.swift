import UI
import PLUI
import CoreFoundationLib

protocol ZusTransferFormViewProtocol: AnyObject,
                                      ConfirmationDialogPresentable {
    func setAccountViewModel()
    func showValidationMessages(with data: InvalidZusTransferFormData)
    func updateRecipient(name: String, accountNumber: String)
}

final class ZusTransferFormViewController: UIViewController {
    private let presenter: ZusTransferFormPresenterProtocol
    private let scrollView = UIScrollView()
    private let formView: ZusTransferFormView
    private let bottomView = BottomButtonView(style: .red)
    
    init(presenter: ZusTransferFormPresenterProtocol) {
        self.presenter = presenter
        self.formView = ZusTransferFormView(language: presenter.getLanguage())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureKeyboardDismissGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.addNavigationBarShadow()
        view.layoutIfNeeded()
    }
}

private extension ZusTransferFormViewController {
    
    @objc func goBack() {
        presenter.didSelectClose()
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
            self?.presenter.showConfirmation()
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
        formView.setCurrentActiveFieldType(.none)
    }
}

extension ZusTransferFormViewController: ZusTransferFormViewProtocol {
    func setAccountViewModel() {
        formView.configure(with: presenter.getSelectedAccountViewModels())
    }
    
    func showValidationMessages(with data: InvalidZusTransferFormData) {
        let form = formView.getCurrentFormViewModel()
        formView.showInvalidFormMessages(with: data)
        if data.shouldContinueButtonBeEnabled,
           form.amount != nil {
            bottomView.enableButton()
        } else {
            bottomView.disableButton()
        }
    }
    
    func updateRecipient(name: String, accountNumber: String) {
        formView.updateRecipient(name: name, accountNumber: accountNumber)
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
}

extension ZusTransferFormViewController: ZusTransferFormViewDelegate {

    func didChangeForm(with field: TransferFormCurrentActiveField) {
        presenter.updateTransferFormViewModel(
            with: formView.getCurrentFormViewModel()
        )
        presenter.startValidation(with: field)
    }
    
    func didTapRecipientButton() {
        presenter.showRecipientSelection()
    }
    
    func changeAccountTapped() {
        presenter.showAccountSelector()
    }
}
