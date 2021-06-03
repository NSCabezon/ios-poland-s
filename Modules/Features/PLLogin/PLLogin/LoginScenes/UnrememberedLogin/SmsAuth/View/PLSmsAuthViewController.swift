//
//  PLSmsAuthView.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import UIKit
import UI
import PLUI
import Commons
import IQKeyboardManagerSwift

protocol PLSmsAuthViewProtocol: class, PLLoadingLoginViewCapable, ChangeEnvironmentViewCapable {
    func resetForm()
    func setUserIdentifier(_ identifier: String)
}

final class PLSmsAuthViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLSmsAuthPresenterProtocol

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var regardLabel: UILabel!
    @IBOutlet private weak var documentTextField: PLDocumentTextField!
    @IBOutlet private weak var loginButton: PLLoginButton!
    @IBOutlet private weak var bottonDistance: NSLayoutConstraint!
    @IBOutlet weak var environmentButton: UIButton?

    private lazy var smsConstraintWithoutKeyboard: NSLayoutConstraint? = {
        return self.smsInputCodeView.topAnchor.constraint(equalTo: self.documentTextField.bottomAnchor, constant: 24)
    }()
    private lazy var smsConstraintWithKeyboard: NSLayoutConstraint? = {
        return self.smsInputCodeView.bottomAnchor.constraint(equalTo: self.loginButton.topAnchor, constant: -45)
    }()
    private lazy var smsInputCodeView: PLUIInputCodeView = PLUIInputCodeView(keyboardType: .numberPad,
                                                                                        delegate: self,
                                                                                        facade: PLUIInputCodeSMSFacade(),
                                                                                        elementSize: Constants.smsBoxSize,
                                                                                        requestedPositions: .all,
                                                                                        charactersSet: Constants.smsCharacterSet)
    private var isShowingKeyboard = false {
        didSet {
            self.smsConstraintWithoutKeyboard?.isActive = !isShowingKeyboard
            self.smsConstraintWithKeyboard?.isActive = isShowingKeyboard
        }
    }

    private enum Constants {
        static let smsBoxSize = CGSize(width: 31.0, height: 56.0)
        static let smsCharacterSet: CharacterSet = .decimalDigits
        static let bottomDistance: CGFloat = 32
        static let animationDuration: TimeInterval = 0.2
    }


    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLSmsAuthPresenterProtocol) {
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

extension PLSmsAuthViewController: PLSmsAuthViewProtocol {
    func setUserIdentifier(_ identifier: String) {
        self.documentTextField.setText(identifier)
    }
    
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

private extension PLSmsAuthViewController {
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
        configureSMSAuthView()
        setAccessibility()
        authenticateInit()
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
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func configureButtons() {
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginButtonDidPressed)))
    }

    func configureSMSAuthView() {
        self.view.addSubview(self.smsInputCodeView)
        self.smsConstraintWithoutKeyboard?.isActive = true
        NSLayoutConstraint.activate([
            self.smsInputCodeView.leadingAnchor.constraint(equalTo: self.documentTextField.leadingAnchor),
            self.smsInputCodeView.trailingAnchor.constraint(equalTo: self.documentTextField.trailingAnchor)
        ])
    }

    func authenticateInit() {
        self.presenter.authenticateInit()
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
        self.presenter.authenticate()
        // TODO: PG Remove the following lines: 2
        let coordinatorDelegate: PLLoginCoordinatorProtocol = self.dependenciesResolver.resolve(for: PLLoginCoordinatorProtocol.self)
        coordinatorDelegate.goToPrivate(.classic)
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

extension PLSmsAuthViewController: PasswordPTTextFieldDelegate {
    public func enterDidPressed() {
        self.loginButtonDidPressed()
    }
}

extension PLSmsAuthViewController: RememberMeViewDelegate {
    func checkButtonPressed() {
        self.view.endEditing(true)
    }
}

extension PLSmsAuthViewController: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string != " " else { return false }
        let currentText = self.documentTextField.introducedText
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count > self.documentTextField.maxLenght  {
            let changeUpdatedText = updatedText.substring(0, self.documentTextField.maxLenght) ?? ""
            self.documentTextField.introducedText = changeUpdatedText
            self.documentTextField.textField.text = changeUpdatedText
            return false
        } else {
            if updatedText.count >= 6 {
                loginButton?.set(localizedStylableText: localized("generic_button_continue"), state: .normal)
                loginButton.isEnabled = true
            }
            else {
                loginButton?.set(localizedStylableText: localized("pl_login_button_access"), state: .normal)
                loginButton.isEnabled = false
            }
            self.documentTextField.introducedText = updatedText
            return true
        }
    }
}

extension  PLSmsAuthViewController: PLUIInputCodeViewDelegate {
    func codeView(_ view: PLUIInputCodeView, didChange string: String, for position: NSInteger) {

        if let first = view.firstEmptyRequested(), first >= 6 {
            self.loginButton.isEnabled = true
        } else {
            self.loginButton.isEnabled = false
        }
    }

    func codeView(_ view: PLUIInputCodeView, willChange string: String, for position: NSInteger) -> Bool {
        if string.count == 0 { return true }
        guard string.count > 0,
              let character = UnicodeScalar(string),
              view.charactersSet.contains(character) == true else {
            return false
        }
        return true
    }

    func codeView(_ view: PLUIInputCodeView, didBeginEditing position: NSInteger) {
    }

    func codeView(_ view: PLUIInputCodeView, didEndEditing position: NSInteger) {
    }

    func codeView(_ view: PLUIInputCodeView, didDelete position: NSInteger) {
    }
}
