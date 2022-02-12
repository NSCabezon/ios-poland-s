import UI
import PLUI
import CoreFoundationLib
import Foundation
import SANLegacyLibrary
import PLCommons
import IQKeyboardManagerSwift

protocol MobileTransferFormViewControllerProtocol: AnyObject,
                                                   ErrorPresentable,
                                                   LoaderPresentable,
                                                   ConfirmationDialogPresentable {
    func setAccountViewModel()
    func showValidationMessages(messages: InvalidMobileTransferFormMessages)
    func fillWithContact(contact: MobileContact?)
}

final class MobileTransferFormViewController: UIViewController {
    
    private let presenter: MobileTransferFormPresenterProtocol
    private let scrollView = UIScrollView()
    private let headerView = NavigationBarBottomExtendView()
    private let headerContent = PhoneTransferRegistrationAccountView()
    private let formView = MobileTransferFormView()
    private let bottomView = BottomButtonView()
    
    init(presenter: MobileTransferFormPresenterProtocol) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        prepareNavigationBar()
    }
}

private extension MobileTransferFormViewController {
    
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
        configureKeyboardDismissGesture()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(headerView)
        headerView.addSubview(headerContent)
        scrollView.addSubview(formView)
        view.addSubview(bottomView)
        formView.delegate = self
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: localized("pl_blik_title_transferBlik")))
            .setLeftAction(.back(action: #selector(goBack)))
            .setRightActions(.close(action: #selector(closeProcess)))
            .build(on: self, with: nil)
    }
    
    func prepareStyles() {
        view.backgroundColor = .white
        bottomView.configure(title: localized("pl_blik_button_doneTransfer")) { [weak self] in
            guard let self = self else { return }
            let form = self.formView.getCurrentForm()
            self.presenter.verifyPhoneNumber(phoneNumber: form.phoneNumber ?? "")
        }
        bottomView.disableButton()
        setUpHeaderViewStyle()
    }
    
    func setUpHeaderViewStyle() {
        headerView.backgroundColor = .white
        
        setAccountViewModel()
        headerContent.shouldHideEditButton(presenter.hasUserOneAccount())
        headerContent.setOnChangePress { [weak self] in
            self?.presenter.showAccountSelectorScreen()
        }

        headerContent.configureTitleStyle(textColor: .brownishGray,
                                          font: .santander(family: .text, type: .bold, size: 12))
        headerContent.configureAccountTextStyle(textColor: .lisboaGray,
                                                font: .santander(family: .text, type: .regular, size: 15))
    }
    
    func setUpLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        formView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerContent.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Const.Size.headerView.height),
            
            headerContent.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 11),
            headerContent.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 11),
            headerContent.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -11),
            headerContent.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -11),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            formView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            formView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            formView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor),
            formView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension MobileTransferFormViewController: MobileTransferFormViewControllerProtocol {
    func setAccountViewModel() {
        guard let account = presenter.getSelectedAccount() else { return }
        let availableFundsText = NumberFormatter.PLAmountNumberFormatter.string(for: account.availableFunds.amount)
            ?? "\(account.availableFunds.amount) \(account.availableFunds.currency)"
        let accountViewModel = PhoneTransferRegistrationFormViewModel.AccountViewModel(
            title: localized("pl_blik_label_accountTransfter"),
            accountName: account.name,
            availableFunds: availableFundsText,
            accountNumber: account.number
        )
        headerContent.configure(with: accountViewModel)
    }
    
    func showValidationMessages(messages: InvalidMobileTransferFormMessages) {
        let currentForm = formView.getCurrentForm()
        formView.showInvalidFormMessages(messages)
        if messages.shouldContinueButtonBeEnabled,
           currentForm.phoneNumber != nil,
           !(currentForm.phoneNumber?.isEmpty ?? true),
           currentForm.amount != nil {
            bottomView.enableButton()
        } else {
            bottomView.disableButton()
        }
    }
    
    func fillWithContact(contact: MobileContact?) {
        formView.fillWith(contact: contact)
        let form = formView.getCurrentForm()
        if contact != nil {
            presenter.startValidation(for: form, validateNumber: true)
        }
    }
}
extension MobileTransferFormViewController: MobileTransferFormViewProtocol {
    func didChangeForm(phoneNumberStartedEdited: Bool) {
        let form = formView.getCurrentForm()
        presenter.startValidation(for: form, validateNumber: phoneNumberStartedEdited)
    }
    
    func showContacts() {
        presenter.showContacts()
    }
}

extension MobileTransferFormViewController {
    struct Const {
        struct Size {
            static let headerView: CGSize = .init(width: .zero, height: 68)
        }
    }
}
