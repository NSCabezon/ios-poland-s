import UIKit
import UI
import PLUI
import Commons
import IQKeyboardManagerSwift

protocol PLUnrememberedLoginIdViewProtocol: class, PLLoadingLoginViewCapable, ChangeEnvironmentViewCapable {
    func resetForm()
}

final class PLUnrememberedLoginIdViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLUnrememberedLoginIdPresenterProtocol
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var regardLabel: UILabel!
    @IBOutlet private weak var documentTextField: PLDocumentTextField!
    @IBOutlet private weak var loginButton: PLLoginButton!
    @IBOutlet private weak var bottonDistance: NSLayoutConstraint!
    @IBOutlet weak var environmentButton: UIButton?
    @IBOutlet weak var tooltipButton: UIButton!


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

extension PLUnrememberedLoginIdViewController: PLUnrememberedLoginIdViewProtocol {
    
    func didUpdateEnvironments() {
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func resetForm() {
        self.documentTextField?.setText("")
    }
    
    @IBAction func didSelectChooseEnvironment(_ sender: Any) {
        self.chooseEnvironment()
    }
    
    func chooseEnvironment() {
        self.presenter.didSelectChooseEnvironment()
    }
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
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureButtons() {
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginButtonDidPressed)))
        tooltipButton.set(localizedStylableText: localized("login_button_lostKey"), state: .normal)
        tooltipButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        tooltipButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 14.0)
        tooltipButton.setImage(PLAssets.image(named: "tooltipIcon"), for: .normal)
        tooltipButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
        tooltipButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tooltipButtonDidPressed)))
    }
    
    func setAccessibility() {
        documentTextField.accessibilityIdentifier = AccessibilityUnrememberedLogin.inputTextDocument.rawValue
        loginButton.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnEnter.rawValue
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
        // TODO
    }

    @objc func tooltipButtonDidPressed() {
        let dialog = Dialog(title: "", items: [Dialog.Item.text("otp_text_popup_error")], image: "icnAlertError", actionButton: Dialog.Action(title: "generic_button_accept", style: .red, action: {
                    print("Action")
                }), isCloseButtonAvailable: true)
        dialog.show(in: self)
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

extension PLUnrememberedLoginIdViewController: PasswordPTTextFieldDelegate {
    public func enterDidPressed() {
        self.loginButtonDidPressed()
    }
}

extension PLUnrememberedLoginIdViewController: RememberMeViewDelegate {
    func checkButtonPressed() {
        self.view.endEditing(true)
    }
}
