
import UI
import PLUI
import CoreFoundationLib
import IQKeyboardManagerSwift

protocol CharityTransferFormViewProtocol: AnyObject,
                                          ConfirmationDialogPresentable {
    func setAccountViewModel()
    func showValidationMessages(messages: InvalidCharityTransferFormMessages)
    func clearForm()
}

final class CharityTransferFormViewController: UIViewController {
    private let presenter: CharityTransferFormPresenterProtocol
    private let scrollView = UIScrollView()
    private let formView: CharityTransferFormView
    private let bottomView = BottomButtonView(style: .red)
    
    init(presenter: CharityTransferFormPresenterProtocol) {
        self.presenter = presenter
        self.formView = CharityTransferFormView(language: presenter.getLanguage(),
                                                charityTransferSettings: presenter.getCharityTransferSettings())
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
        IQKeyboardManager.shared.enableAutoToolbar = false
        view.layoutIfNeeded()
    }
}

private extension CharityTransferFormViewController {
    
    @objc func goBack() {
        presenter.didSelectClose()
    }
    
    @objc func closeProcess() {
        presenter.didSelectCloseProcess()
    }
    
    func setUp() {
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        setUpLayout()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(formView)
        view.addSubview(bottomView)
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: localized("pl_foundtrans_title_foundTransfer")))
            .setLeftAction(.back(action: #selector(goBack))) //TODO: need to change back action to back send money screen
            .setRightActions(.close(action: #selector(closeProcess)))
            .build(on: self, with: nil)
    }
    
    func prepareStyles() {
        view.backgroundColor = .white
        bottomView.configure(title: localized("pl_foundtrans_button_doneTransfer")) { [weak self] in
            self?.presenter.confirmTransfer()
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
}

extension CharityTransferFormViewController: CharityTransferFormViewProtocol {
    func setAccountViewModel() {
        formView.configure(with: presenter.getSelectedAccountViewModels())
    }
    
    func showValidationMessages(messages: InvalidCharityTransferFormMessages) {
        let form = formView.getCurrentFormViewModel()
        formView.showInvalidFormMessages(messages)
        if messages.shouldContinueButtonBeEnabled,
           form.amount != nil {
            bottomView.enableButton()
        } else {
            bottomView.disableButton()
        }
    }
    
    func clearForm() {
        bottomView.disableButton()
        formView.clearForm()
        presenter.clearForm()
    }
}

extension CharityTransferFormViewController: CharityTransferFormViewDelegate {
    func didChangeForm() {
        presenter.updateTransferFormViewModel(
            with: formView.getCurrentFormViewModel()
        )
        presenter.startValidation()
    }
    
    func changeAccountTapped() {
        presenter.showAccountSelector()
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
