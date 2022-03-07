import OpenCombine
import UI
import IQKeyboardManagerSwift
import CoreFoundationLib
import PLUI

final class ZusSMETransferFormViewController: UIViewController {
    private let viewModel: ZusSMETransferFormViewModel
    private var subscriptions: Set<AnyCancellable> = []
    private let dependencies: ZusSMETransferFormDependenciesResolver
    private let navigationBarItemBuilder: NavigationBarItemBuilder
    private let scrollView = UIScrollView()
    private let formView: ZusSMETransferFormView
    private let bottomView = BottomButtonView(style: .red)

    init(dependencies: ZusSMETransferFormDependenciesResolver) {
        self.dependencies = dependencies
        viewModel = dependencies.resolve()
        navigationBarItemBuilder = dependencies.external.resolve()
        formView = ZusSMETransferFormView(language: viewModel.language)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
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
    }
}

private extension ZusSMETransferFormViewController {
    func setUp() {
        addSubviews()
        configureView()
        prepareNavigationBar()
        setUpLayout()
        addKeyboardObserver()
    }
    
    func addSubviews() {
        [scrollView, bottomView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        formView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(formView)
    }
    
    func configureView() {
        view.backgroundColor = .white
        bottomView.configure(title: localized("pl_zusTransfer_button_doneTransfer")) { [weak self] in
            //TODO: will be implemented
        }
        bottomView.disableButton()
    }
    
    func setUpLayout() {
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
    
    func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .white,
            title: .title(key: localized("pl_zusTransfer_toolbar")
            )
        )
        .setLeftAction(.back(action: .closure(didSelectGoBack)))
        .setRightActions(.close(action: .closure(didSelectCloseProcess)))
        .build(on: self, with: nil)
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
        
    @objc func keyboardWillHide(notification: NSNotification) {
        //TODO: same as in zus transfer
    }
    
    @objc func didSelectGoBack() {
        viewModel.didSelectGoBack()
    }
    
    @objc func didSelectCloseProcess() {
        viewModel.didSelectCloseProcess()
    }
}
