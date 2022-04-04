import UI
import PLUI
import IQKeyboardManagerSwift
import CoreFoundationLib
import IQKeyboardManagerSwift

protocol ZusSmeTransferFormViewProtocol: AnyObject,
                                         ConfirmationDialogPresentable,
                                         LoaderPresentable,
                                         ErrorPresentable {
    func updateRecipient(name: String, accountNumber: String)
    func setAccountViewModel()
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
        //TODO: later
    }
    
    @objc func closeProcess() {
        //TODO: later
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
            //TODO: show confirmation
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
}

extension ZusSmeTransferFormViewController: ZusSmeTransferFormViewDelegate {

    func changeAccountTapped() {
        presenter.showAccountSelector()
    }
    
    func updateRecipient(name: String, accountNumber: String) {
        //TODO: update recipient in form
    }
}
