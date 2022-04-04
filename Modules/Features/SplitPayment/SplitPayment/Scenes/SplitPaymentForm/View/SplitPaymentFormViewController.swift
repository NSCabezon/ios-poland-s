import UI
import PLUI
import IQKeyboardManagerSwift
import CoreFoundationLib
import IQKeyboardManagerSwift

protocol SplitPaymentFormViewProtocol: AnyObject,
                                      ConfirmationDialogPresentable,
                                      LoaderPresentable,
                                      ErrorPresentable {
    
}

final class SplitPaymentFormViewController: UIViewController {
    
    private let presenter: SplitPaymentFormPresenterProtocol
    private let scrollView = UIScrollView()
    private let bottomView = BottomButtonView(style: .red)
    private let formView: SplitPaymentFormView
    
    init(presenter: SplitPaymentFormPresenterProtocol) {
        self.presenter = presenter
        self.formView = SplitPaymentFormView()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.addNavigationBarShadow()
        IQKeyboardManager.shared.enableAutoToolbar = false
        view.layoutIfNeeded()
    }
}

private extension SplitPaymentFormViewController {
    
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
            title: .title(key: localized("#pl_split_payment_navigation_title")
            )
        )
        .setLeftAction(.back(action: .closure(goBack)))
        .setRightActions(.close(action: .closure(closeProcess)))
        .build(on: self, with: nil)
    }
    
    func configureView() {
        view.backgroundColor = .white
        bottomView.configure(title: localized("#pl_split_payment_button_doneTransfer")) { [weak self] in
            // TODO: configure bottom view
        }
        bottomView.disableButton()
    }
    
    func setUpLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        // TODO: keyboardWillHide
    }
}

extension SplitPaymentFormViewController: SplitPaymentFormViewProtocol {
    
}
