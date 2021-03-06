import UIKit
import UI
import PLUI
import CoreFoundationLib
import PLCommons
import IQKeyboardManagerSwift

protocol PLUnrememberedLoginIdViewProtocol: PLGenericErrorPresentableCapable, ChangeEnvironmentViewCapable {
    func resetForm()
    func showAccountPermanentlyBlockedDialog()
    func showInvalidSCADialog(_ completion: @escaping (() -> Void))
    func showAccountTemporaryBlockedDialog(_ configuration: UnrememberedLoginConfiguration)
}

final class PLUnrememberedLoginIdViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLUnrememberedLoginIdPresenterProtocol
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var regardLabel: UILabel!
    @IBOutlet private weak var documentTextField: PLDocumentTextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet weak var environmentButton: UIButton?
    @IBOutlet weak var tooltipButton: UIButton!
    @IBOutlet weak var buttonBottomAnchorConstraint: NSLayoutConstraint!
    @IBOutlet weak var textfieldConstraintWithoutKeyboard: NSLayoutConstraint!
    private var isShowingKeyboard = false {
        didSet {
            textfieldConstraintWithKeyboard.isActive = isShowingKeyboard
            textfieldConstraintWithoutKeyboard.isActive = !isShowingKeyboard
        }
    }

    @IBOutlet weak var textfieldConstraintWithKeyboard: NSLayoutConstraint!
    private enum Constants {
        static let bottomDistance: CGFloat = 67
        static let animationDuration: TimeInterval = 0.2

        enum Accessibility: String {
            case loginUnregisteredContainerNikAlias
            case loginUnregisteredTextNikAlias
            case loginUnregisteredTitleLabel = "pl_login_label_login"
            case loginUnregisteredLabelGreeting
            case loginUnregisteredBtnShowDialogLostKey
            case loginUnregisteredBtnAccess
            case sanIcon = "icnSanWhite"
        }
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLUnrememberedLoginIdPresenterProtocol) {
        self.presenter = presenter
        self.dependenciesResolver = dependenciesResolver
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        self.presenter.viewDidLoad()
        self.setupViews()

        let compilation = dependenciesResolver.resolve(for: CompilationProtocol.self)
        let service = compilation.keychain.service
        if service.contains("UAT") || service.contains("DEV") {
            self.configureDebugMenuButton() // Temporary [DEBUG WELCOME] on Login
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.viewWillAppear()
        self.addKeyboardObserver()
        self.setNavigationBar()
    }
    
    func setNavigationBar() {
        NavigationBarBuilder(style: .clear(tintColor: .white), title: .none)
            .setRightActions(.menu(action: #selector(didSelectMenu)))
            .build(on: self, with: nil)
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func didSelectMenu() {
        self.presenter.didSelectMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presenter.viewWillDissappear()
    }
}

extension PLUnrememberedLoginIdViewController: PLUnrememberedLoginIdViewProtocol {
    
    func didUpdateEnvironments() {
    }
    
    func resetForm() {
        self.documentTextField?.setText("")
    }

    func showAccountPermanentlyBlockedDialog() {
        PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_userBlocked")
    }

    func showInvalidSCADialog(_ completion: @escaping (() -> Void)) {
        PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_attemptLast", completion: completion)
    }

    func showAccountTemporaryBlockedDialog(_ configuration: UnrememberedLoginConfiguration) {
        guard let unblockRemainingTimeInSecs = configuration.unblockRemainingTimeInSecs else { return }
        PLDialogTime(dateTimeStamp: unblockRemainingTimeInSecs) { [weak self] allowLogin in
            if allowLogin {
                self?.presenter.setAllowLoginBlockedUsers()
            }
        }.show(in: self)
    }

    @IBAction func didSelectChooseEnvironment(_ sender: Any) {
        self.chooseEnvironment()
    }
    
    func chooseEnvironment() {
        self.presenter.didSelectChooseEnvironment()
    }
    
    func configureDebugMenuButton() { // Temporary [DEBUG WELCOME] on Login
        let button = UIButton()
        button.setTitle("DEBUG MENU", for: .normal)
        button.addTarget(self, action: #selector(didSelectDebugMenu(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }
    
    @objc func didSelectDebugMenu(_ sender: Any) { // Temporary [DEBUG WELCOME] on Login
        let launcherDelegate = dependenciesResolver.resolve(for: DebugMenuLauncherDelegate.self)
        launcherDelegate.start()
    }
}

public protocol DebugMenuLauncherDelegate { // Temporary [DEBUG WELCOME] on Login
    func start()
}

private extension PLUnrememberedLoginIdViewController {
    func isKeyboardDismisserAllowed() -> Bool {
        return parent == nil || parent is UINavigationController
    }
    
    func setupViews() {
        commonInit()
    }
    
    func commonInit() {
        setupEnvironmentButton()
        sanIconImageView?.image = Assets.image(named: "icnSanWhiteLisboa")
        configureRegardLabel()
        configureBackground()
        configureTextFields()
        configureButtons()
        configureNavigationController()
        configureKeyboard()
        setAccessibilityIdentifiers()
    }
    
    func configureRegardLabel() {
        regardLabel.font = .santander(family: .text, type: .light, size: 40)
        regardLabel.textColor = UIColor.Legacy.uiWhite
        regardLabel.text = regardNow()
    }
    
    func configureBackground() {
        backgroundImageView.image = TimeImageAndGreetingViewModel.shared.getBackground()
        backgroundImageView.contentMode = .scaleAspectFill
    }
    
    func configureTextFields() {
        documentTextField.textField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureButtons() {
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginButtonDidPressed)))
        loginButton.set(localizedStylableText: localized("generic_button_continue"), state: .normal)
        tooltipButton.set(localizedStylableText: localized("pl_login_label_whatIsLogin"), state: .normal)
        tooltipButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        tooltipButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 14.0)
        tooltipButton.setImage(PLAssets.image(named: "tooltipIcon"), for: .normal)
        tooltipButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
        tooltipButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tooltipButtonDidPressed)))
    }

    func setAccessibilityIdentifiers() {
        documentTextField.accessibilityIdentifier = Constants.Accessibility.loginUnregisteredContainerNikAlias.rawValue
        documentTextField.titleLabel.accessibilityIdentifier = Constants.Accessibility.loginUnregisteredTitleLabel.rawValue
        documentTextField.textField .accessibilityIdentifier = Constants.Accessibility.loginUnregisteredTextNikAlias.rawValue
        loginButton.accessibilityIdentifier = Constants.Accessibility.loginUnregisteredBtnAccess.rawValue
        regardLabel.accessibilityIdentifier = Constants.Accessibility.loginUnregisteredLabelGreeting.rawValue
        sanIconImageView.accessibilityIdentifier = Constants.Accessibility.sanIcon.rawValue
        tooltipButton.accessibilityIdentifier = Constants.Accessibility.loginUnregisteredBtnShowDialogLostKey.rawValue
    }
    
    func regardNow() -> String {
        return localized(TimeImageAndGreetingViewModel.shared.greetingTextKey.rawValue).text
    }

    func configureNavigationController() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    func configureKeyboard() {
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func loginButtonDidPressed() {
        self.view.endEditing(true)
        self.presenter.login(identification: documentTextField.introducedDocument())
    }

    @objc func tooltipButtonDidPressed() {
        let keyTitle = "generic_alert_information"
        let desc = Dialog.Item.styledConfiguredText(localized("pl_login_alert_whatIsLogin"), configuration: LocalizedStylableTextConfiguration(
            font: .santander(family: .text, type: .regular, size: 18),
            alignment: .center,
            lineHeightMultiple: 1,
            lineBreakMode: .byTruncatingTail
        ))
        let acceptAction = Dialog.Action(title: "generic_button_understand", style: .red, action: {})
        let image = "icnInfoPg"
        self.showDialog(title: keyTitle, items: [desc], image: image, action: acceptAction, isCloseOptionAvailable: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard self.isShowingKeyboard == false else { return }
        self.isShowingKeyboard = true

        guard  let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame: CGRect = keyboardFrameValue.cgRectValue
        buttonBottomAnchorConstraint.constant = -keyboardFrame.height - Constants.bottomDistance
        if let loginButton = loginButton {
            view.bringSubviewToFront(loginButton)
        }
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.regardLabel?.alpha = 0.0
            self?.view.layoutSubviews()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.isShowingKeyboard = false
        buttonBottomAnchorConstraint.constant = -Constants.bottomDistance
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.regardLabel?.alpha = 1.0
            self?.view.layoutSubviews()
        }
    }
}

extension PLUnrememberedLoginIdViewController: RememberMeViewDelegate {
    func checkButtonPressed() {
        self.view.endEditing(true)
    }
}

extension PLUnrememberedLoginIdViewController: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string != " " else { return false }
        let currentText = self.documentTextField.introducedText
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count > 20 {
            return false
        } else {
            loginButton.isEnabled = updatedText.count >= 6
            return true
        }
    }
}
