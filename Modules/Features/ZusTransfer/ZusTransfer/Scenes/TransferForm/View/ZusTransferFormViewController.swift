import UI
import PLUI
import Commons

protocol ZusTransferFormViewProtocol: AnyObject,
                                      ConfirmationDialogPresentable {
    func setAccountViewModel()
    func showValidationMessages(messages: InvalidZusTransferFormMessages)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(formView)
        view.addSubview(bottomView)
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: localized("#Przelew ZUS")))
            .setLeftAction(.back(action: #selector(goBack))) //TODO: need to change back action to back send money screen
            .setRightActions(.close(action: #selector(closeProcess)))
            .build(on: self, with: nil)
    }
    
    func configureView() {
        view.backgroundColor = .white
        bottomView.configure(title: localized("#Gotowe")) {
            // TODO: Add ready botton action
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

extension ZusTransferFormViewController: ZusTransferFormViewProtocol {
    func setAccountViewModel() {
        formView.configure(with: presenter.getSelectedAccountViewModels())
    }
    
    func showValidationMessages(messages: InvalidZusTransferFormMessages) {
        let form = formView.getCurrentFormViewModel()
        formView.showInvalidFormMessages(messages)
        if messages.shouldContinueButtonBeEnabled,
           form.amount != nil {
            bottomView.enableButton()
        } else {
            bottomView.disableButton()
        }
    }
}

extension ZusTransferFormViewController: ZusTransferFormViewDelegate {
    func didChangeForm() {
      //TODO: Implemented form
    }
    
    func changeAccountTapped() {
        presenter.showAccountSelector()
    }
}
