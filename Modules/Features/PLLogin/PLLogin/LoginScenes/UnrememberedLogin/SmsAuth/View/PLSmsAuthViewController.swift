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
}

final class PLSmsAuthViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLSmsAuthPresenterProtocol

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var regardLabel: UILabel!
    @IBOutlet weak var smsLabel: UILabel!
    @IBOutlet private weak var loginButton: PLLoginButton!
    @IBOutlet private weak var bottonDistance: NSLayoutConstraint!
    @IBOutlet weak var environmentButton: UIButton?

    private lazy var smsConstraintWithoutKeyboard: NSLayoutConstraint? = {
        return self.smsInputCodeView.topAnchor.constraint(equalTo: self.smsLabel.bottomAnchor, constant: Constants.bottomDistance)
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
        static let smsBoxSize = CGSize(width: 39.0, height: 56.0)
        static let smsCharacterSet: CharacterSet = .decimalDigits
        static let bottomDistance: CGFloat = 10
        static let animationDuration: TimeInterval = 0.2
        static let minimumPositionsFulfilled = 8
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
    
    func didUpdateEnvironments() {
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    func resetForm() {
        //TODO
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
        configureLabels()
        configureBackground()
        configureTextFields()
        configureButtons()
        configureSMSAuthView()
        setAccessibility()
    }

    func configureLabels() {
        regardLabel.font = .santander(family: .text, type: .light, size: 40)
        regardLabel.textColor = UIColor.Legacy.uiWhite
        regardLabel.text = regardNow()
        smsLabel.font = .santander(family: .text, type: .regular, size: 12)
        smsLabel.textColor = UIColor.Legacy.uiWhite
        smsLabel.text = localized("pl_login_hint_smsCode").plainText
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
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(smsSendButtonDidPressed)))
    }

    func configureSMSAuthView() {
        self.view.addSubview(self.smsInputCodeView)
        self.smsConstraintWithoutKeyboard?.isActive = true
        NSLayoutConstraint.activate([
            self.smsInputCodeView.leadingAnchor.constraint(equalTo: self.smsLabel.leadingAnchor),
            self.smsInputCodeView.trailingAnchor.constraint(equalTo: self.smsLabel.trailingAnchor)
        ])
    }

    func setAccessibility() {
        smsLabel.accessibilityIdentifier = AccessibilityUnrememberedLogin.inputTextDocument.rawValue
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

    @objc func smsSendButtonDidPressed() {
        self.view.endEditing(true)
        guard let smsCode = self.smsInputCodeView.fulfilledText() else {
            // TODO: return error. smsCode can't be empty
            return
        }
        self.presenter.authenticate(smsCode: smsCode)
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
        self.smsSendButtonDidPressed()
    }
}

extension PLSmsAuthViewController: RememberMeViewDelegate {
    func checkButtonPressed() {
        self.view.endEditing(true)
    }
}

extension  PLSmsAuthViewController: PLUIInputCodeViewDelegate {
    func codeView(_ view: PLUIInputCodeView, didChange string: String, for position: NSInteger) {
        if let first = view.firstEmptyRequested(), first > Constants.minimumPositionsFulfilled {
            self.loginButton.isEnabled = true
        } else {
            self.loginButton.isEnabled = view.isFulfilled()
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
