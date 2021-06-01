import UIKit
import UI
import PLUI
import Commons
import IQKeyboardManagerSwift

protocol PLUnrememberedLoginNormalPwdViewProtocol: AnyObject, PLLoadingLoginViewCapable, ChangeEnvironmentViewCapable {
    func resetForm()
    func setUserIdentifier(_ identifier: String)
}

final class PLUnrememberedLoginNormalPwdViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLUnrememberedLoginNormalPwdPresenterProtocol
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var regardLabel: UILabel!
    @IBOutlet private weak var documentTextField: PLDocumentTextField!
    @IBOutlet private weak var loginButton: PLLoginButton!
    @IBOutlet weak var environmentButton: UIButton?
    @IBOutlet weak var buttonBottomAnchorConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    private var isShowingKeyboard = false

    private enum Constants {
        static let bottomDistance: CGFloat = 32
        static let animationDuration: TimeInterval = 0.2
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLUnrememberedLoginNormalPwdPresenterProtocol) {
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
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}

extension PLUnrememberedLoginNormalPwdViewController: PLUnrememberedLoginNormalPwdViewProtocol {
    func setUserIdentifier(_ identifier: String) {
        self.documentTextField.setText(identifier)
    }

    
    func didUpdateEnvironments() {
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    func resetPassword() {
        self.passwordTextField?.reset()
    }
    
    func resetForm() {
        self.passwordTextField?.setText("")
    }
    
    @IBAction func didSelectChooseEnvironment(_ sender: Any) {
        self.chooseEnvironment()
    }
    
    func chooseEnvironment() {
        self.presenter.didSelectChooseEnvironment()
    }
}

private extension PLUnrememberedLoginNormalPwdViewController {
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
        setAccessibility()
    }
    
    func configureRegardLabel() {
        regardLabel.font = .santander(family: .text, type: .light, size: 40)
        regardLabel.textColor = UIColor.Legacy.uiWhite
        regardLabel.text = regardNow()
    }
    
    func configureBackground() {
        backgroundImageView.image = TimeImageAndGreetingViewModel().backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
    }
    
    func configureTextFields() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.documentTextField.isUserInteractionEnabled = false
        passwordTextField?.setPlaceholder(localized("login_hint_password").plainText)
        passwordTextField?.delegate = self
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureButtons() {
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginButtonDidPressed)))
    }
    
    func setAccessibility() {
        documentTextField.accessibilityIdentifier = AccessibilityUnrememberedLogin.inputTextDocument.rawValue
        loginButton.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnEnter.rawValue
        passwordTextField?.accessibilityIdentifier = AccessibilityUnrememberedLogin.inputTextPassword.rawValue
    }
    
    func regardNow() -> String {
        return localized(TimeImageAndGreetingViewModel().greetingTextKey.rawValue).plainText
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
        self.presenter.goToSMSScene()
        // TODO
    }

    @objc func tooltipButtonDidPressed() {
        let dialog = Dialog(title: "", items: [Dialog.Item.text("otp_text_popup_error")], image: "icnAlertError", actionButton: Dialog.Action(title: "generic_button_accept", style: .red, action: {
                    print("Action")
                }), isCloseButtonAvailable: true)
        dialog.show(in: self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard self.isShowingKeyboard == false else { return }
        self.isShowingKeyboard = true
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        guard  let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame: CGRect = keyboardFrameValue.cgRectValue
        buttonBottomAnchorConstraint.constant = -keyboardFrame.height + Constants.bottomDistance
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
        IQKeyboardManager.shared.enableAutoToolbar = true
        buttonBottomAnchorConstraint.constant = -Constants.bottomDistance
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.regardLabel?.alpha = 1.0
            self?.view.layoutSubviews()
        }
    }
    
    func recoverPasswordOrNewRegistration() {
        self.presenter.recoverPasswordOrNewRegistration()
    }
}

extension PLUnrememberedLoginNormalPwdViewController: PasswordTextFieldDelegate {
    public func enterDidPressed() {
        self.loginButtonDidPressed()
    }
}

extension PLUnrememberedLoginNormalPwdViewController: RememberMeViewDelegate {
    func checkButtonPressed() {
        self.view.endEditing(true)
    }
}
