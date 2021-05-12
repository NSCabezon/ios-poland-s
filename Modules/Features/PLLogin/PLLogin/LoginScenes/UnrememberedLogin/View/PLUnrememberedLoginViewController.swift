import UIKit
import UI
import Commons
import IQKeyboardManagerSwift

protocol PLUnrememberedLoginViewProtocol: class, PLLoadingLoginViewCapable, ChangeEnvironmentViewCapable {
    func resetPassword()
    func resetForm()
}

final class PLUnrememberedLoginViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLUnrememberedLoginPresenterProtocol
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var regardLabel: UILabel!
    @IBOutlet private weak var documentTextField: DocumentPTTextField!
    @IBOutlet private weak var passwordTextField: PasswordPTTextField!
    @IBOutlet private weak var rememberMeView: RememberMeView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var restoreButton: ResponsiveStateButton!
    @IBOutlet private weak var bottonDistance: NSLayoutConstraint!
    @IBOutlet weak var environmentButton: UIButton?

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLUnrememberedLoginPresenterProtocol) {
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

extension PLUnrememberedLoginViewController: PLUnrememberedLoginViewProtocol {
    
    func didUpdateEnvironments() {
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func resetPassword() {
        self.passwordTextField?.reset()
    }
    
    func resetForm() {
        self.passwordTextField?.reset()
        self.documentTextField?.setText("")
    }
    
    @IBAction func didSelectChooseEnvironment(_ sender: Any) {
        self.chooseEnvironment()
    }
    
    func chooseEnvironment() {
        self.presenter.didSelectChooseEnvironment()
    }
}

private extension PLUnrememberedLoginViewController {
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
        //backgroundImageView.image = TimeImageAndGreetingViewModel().backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
    }
    
    func configureTextFields() {
        documentTextField.setReturnAction { [weak self] in self?.passwordTextField?.becomeResponder() }
        passwordTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureButtons() {
        rememberMeView.setTitle(localized("login_radioButton_rememberUser").plainText)
        rememberMeView.setDelegate(self)
        loginButton.set(localizedStylableText: localized("login_button_enter"), state: .normal)
        loginButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        loginButton.backgroundColor = UIColor.santanderRed
        loginButton.layer.cornerRadius = (loginButton?.frame.height ?? 0.0) / 2.0
        loginButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 18.0)
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginButtonDidPressed)))
        restoreButton.backgroundColor = UIColor.clear
        restoreButton.setTitle(localized("pt_login_button_newRegistrationOr").plainText, for: .normal)
        restoreButton.titleLabel?.font = UIFont.santander(family: .text, type: .regular, size: 14)
        restoreButton.titleLabel?.textColor = UIColor.Legacy.uiWhite
        restoreButton.onTouchAction = { [weak self] _ in
            self?.recoverPasswordOrNewRegistration()
        }
    }
    
    func setAccessibility() {
        documentTextField.accessibilityIdentifier = AccessibilityUnrememberedLogin.inputTextDocument.rawValue
        passwordTextField.accessibilityIdentifier = AccessibilityUnrememberedLogin.inputTextPassword.rawValue
        passwordTextField.showBackView?.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnEyeOpen.rawValue
        rememberMeView.checkButton?.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnCheck.rawValue
        loginButton.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnEnter.rawValue
        restoreButton.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnLostKey.rawValue
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
        switch (documentTextField.introducedDocument().isEmpty, passwordTextField.introducedPassword().isEmpty) {
        case (true, true):
            showAlert(with: localized("pt_login_error_userAndPassword"), alertType: .failure)
        case (true, false):
            showAlert(with: localized("pt_login_error_username"), alertType: .failure)
        case (false, true):
            showAlert(with: localized("pt_login_error_password"), alertType: .failure)
        case (false, false):
            guard let remember = rememberMeView?.remember() else { return }
            passwordTextField?.textField?.resignFirstResponder()
            presenter.login(identification: documentTextField.introducedDocument(), magic: passwordTextField.introducedPassword(), remember: remember)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        IQKeyboardManager.shared.enableAutoToolbar = false
        guard  let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame: CGRect = keyboardFrameValue.cgRectValue
        bottonDistance?.constant = keyboardFrame.height
        if let loginButton = loginButton {
            view.bringSubviewToFront(loginButton)
        }
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.regardLabel?.alpha = 0.0
            self?.view.layoutSubviews()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        IQKeyboardManager.shared.enableAutoToolbar = true
        bottonDistance?.constant = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.regardLabel?.alpha = 1.0
            self?.view.layoutSubviews()
        }
    }
    
    func recoverPasswordOrNewRegistration() {
        self.presenter.recoverPasswordOrNewRegistration()
    }
}

extension PLUnrememberedLoginViewController: PasswordPTTextFieldDelegate {
    public func enterDidPressed() {
        self.loginButtonDidPressed()
    }
}

extension PLUnrememberedLoginViewController: RememberMeViewDelegate {
    func checkButtonPressed() {
        self.view.endEditing(true)
    }
}
