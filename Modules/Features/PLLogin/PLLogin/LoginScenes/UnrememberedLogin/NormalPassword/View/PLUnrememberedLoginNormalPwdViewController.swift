import UIKit
import UI
import PLUI
import Commons
import PLCommons
import IQKeyboardManagerSwift

protocol PLUnrememberedLoginNormalPwdViewProtocol: PLGenericErrorPresentableCapable {
    func resetForm()
    func setUserIdentifier(_ identifier: String)
    func setUserImage(image: UIImage)
}

final class PLUnrememberedLoginNormalPwdViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLUnrememberedLoginNormalPwdPresenterProtocol
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var regardLabel: UILabel!
    @IBOutlet private weak var documentTextField: PLDocumentTextField!
    @IBOutlet private weak var loginButton: PLLoginButton!
    @IBOutlet weak var buttonBottomAnchorConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextField: PLPasswordTextField!
    @IBOutlet weak var textfieldContainerContraintWithoutKeyboard: NSLayoutConstraint!
    @IBOutlet weak var textfieldContainerContraintWithKeyboard: NSLayoutConstraint!
    private let userImageView = UIImageView()
    private var isShowingKeyboard = false {
        didSet {
            textfieldContainerContraintWithKeyboard.isActive = isShowingKeyboard
            textfieldContainerContraintWithoutKeyboard.isActive = !isShowingKeyboard
        }
    }

    private enum Constants {
        static let bottomDistance: CGFloat = 67
        static let animationDuration: TimeInterval = 0.2
        static let userImageSize = CGSize(width: 56.0, height: 56.0)
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
//        self.presenter.didSelectMenu()
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}

extension PLUnrememberedLoginNormalPwdViewController: PLUnrememberedLoginNormalPwdViewProtocol {
    func setUserIdentifier(_ identifier: String) {
        self.documentTextField.setText(identifier)
    }

    func didUpdateEnvironments() {
    }

    func resetPassword() {
        self.passwordTextField?.reset()
    }
    
    func resetForm() {
        self.passwordTextField?.setText("")
    }


    func setUserImage(image: UIImage) {
        self.userImageView.image = image
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
                self?.userImageView.alpha = 1.0
            }
        }
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
        sanIconImageView?.image = Assets.image(named: "icnSanWhiteLisboa")
        configureRegardLabel()
        configureBackground()
        configureTextFields()
        configureButtons()
        configureUserImage()
        configureKeyboard()
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
        passwordTextField?.textField?.delegate = self
    }

    func configureUserImage() {
        self.userImageView.alpha = 0.0
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        self.userImageView.contentMode = .scaleAspectFit
        self.userImageView.layer.cornerRadius = Constants.userImageSize.height/2.0
        self.userImageView.layer.borderWidth = 2.0
        self.userImageView.layer.borderColor = UIColor.white.cgColor
        self.userImageView.layer.masksToBounds = true
        self.view.addSubview(self.userImageView)
        NSLayoutConstraint.activate([
            self.userImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.userImageView.topAnchor.constraint(equalTo: self.regardLabel.bottomAnchor, constant: 15.0),
            self.userImageView.heightAnchor.constraint(equalToConstant: Constants.userImageSize.height),
            self.userImageView.widthAnchor.constraint(equalToConstant: Constants.userImageSize.width)
        ])
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureButtons() {
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginButtonDidPressed)))
        loginButton.set(localizedStylableText: localized("generic_button_continue"), state: .normal)
    }
    
    func setAccessibility() {
        documentTextField.accessibilityIdentifier = AccessibilityUnrememberedLogin.inputTextDocument.rawValue
        loginButton.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnEnter.rawValue
        passwordTextField?.accessibilityIdentifier = AccessibilityUnrememberedLogin.inputTextPassword.rawValue
    }
    
    func regardNow() -> String {
        return localized(TimeImageAndGreetingViewModel().greetingTextKey.rawValue).plainText
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
        self.presenter.login(password: passwordTextField?.hiddenText ?? "")
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
            self?.userImageView.alpha = 0.0
            self?.view.layoutSubviews()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.isShowingKeyboard = false
        buttonBottomAnchorConstraint.constant = -Constants.bottomDistance
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.regardLabel?.alpha = 1.0
            self?.userImageView.alpha = self?.userImageView.image != nil ? 1.0 : 0.0
            self?.view.layoutSubviews()
        }
    }
}

extension PLUnrememberedLoginNormalPwdViewController: PLPasswordTextFieldDelegate {
    public func enterDidPressed() {
        self.loginButtonDidPressed()
    }
}

extension PLUnrememberedLoginNormalPwdViewController: RememberMeViewDelegate {
    func checkButtonPressed() {
        self.view.endEditing(true)
    }
}

extension PLUnrememberedLoginNormalPwdViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string != " " else { return false }
        let currentText = self.passwordTextField.hiddenText
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        guard updatedText.count <= self.passwordTextField.maxLength else { return false }
        self.passwordTextField.hiddenText = updatedText
        self.passwordTextField.updatePassword()
        loginButton.isEnabled = updatedText.count >= 4

        return false
    }
}
