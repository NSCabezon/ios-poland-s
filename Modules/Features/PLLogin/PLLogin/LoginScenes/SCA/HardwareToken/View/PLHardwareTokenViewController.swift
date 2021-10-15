//
//  PLHardwareTokenViewController.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 20/7/21.
//

import UIKit
import UI
import PLUI
import Commons
import PLCommons
import IQKeyboardManagerSwift

protocol PLHardwareTokenViewProtocol: PLGenericErrorPresentableCapable {
    func resetForm()
}

final class PLHardwareTokenViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLHardwareTokenPresenterProtocol

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var regardLabel: UILabel!
    @IBOutlet private weak var loginButton: PLLoginButton!
    @IBOutlet weak var passwordTextField: PLDocumentTextField!
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
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLHardwareTokenPresenterProtocol) {
        self.presenter = presenter
        self.dependenciesResolver = dependenciesResolver
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        self.setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.viewWillAppear()
        self.addKeyboardObserver()
        self.setNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
    }

    func setNavigationBar() {
        NavigationBarBuilder(style: .clear(tintColor: .white), title: .none)
//            .setRightActions(.menu(action: #selector(didSelectMenu)))
            .build(on: self, with: nil)
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc func didSelectMenu() {
        self.presenter.didSelectMenu()
    }
}

extension PLHardwareTokenViewController: PLHardwareTokenViewProtocol {
    func resetForm() {
        //TODO
    }
}

private extension PLHardwareTokenViewController {
    func isKeyboardDismisserAllowed() -> Bool {
        return parent == nil || parent is UINavigationController
    }

    func setupViews() {
        commonInit()

    }

    func commonInit() {
        sanIconImageView?.image = Assets.image(named: "icnSanWhiteLisboa")
        configureLabels()
        configureBackground()
        configureTextFields()
        configureButtons()
        configureKeyboard()
        setAccessibility()
    }

    func configureLabels() {
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
        passwordTextField.state = .secure
        passwordTextField.textField.keyboardType = .numberPad
        passwordTextField.textField.delegate = self
        passwordTextField.configureLoginTypeLabel(text: localized("pl_login_hint_tokenCode"))
        passwordTextField.configureTextTextField(text: nil)
        passwordTextField.textField.returnKeyType = .default
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func configureButtons() {
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(smsSendButtonDidPressed)))
        loginButton.set(localizedStylableText: localized("pl_login_button_access"), state: .normal)
    }

    func setAccessibility() {
        loginButton.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnEnter.rawValue
    }

    func regardNow() -> String {
        return localized(TimeImageAndGreetingViewModel().greetingTextKey.rawValue).plainText
    }
    
    @objc func smsSendButtonDidPressed() {
        presenter.doAuthenticate(token: self.passwordTextField.hiddenText)
        self.view.endEditing(true)
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

extension PLHardwareTokenViewController: RememberMeViewDelegate {
    func checkButtonPressed() {
        self.view.endEditing(true)
    }
}

extension PLHardwareTokenViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if evaluateChars(string) {
            let currentText = passwordTextField.hiddenText
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            guard updatedText.count <= 8 else {
                return false
            }
            passwordTextField.hiddenText = updatedText
            passwordTextField.updatePassword()
            if updatedText.count == 8 {
                loginButton.isEnabled  = true
                textField.resignFirstResponder()
            } else {
                loginButton.isEnabled = false
            }
            return false
        }
        return false
    }
}

func evaluateChars(_ string: String) -> Bool {
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    return allowedCharacters.isSuperset(of: characterSet)
}
