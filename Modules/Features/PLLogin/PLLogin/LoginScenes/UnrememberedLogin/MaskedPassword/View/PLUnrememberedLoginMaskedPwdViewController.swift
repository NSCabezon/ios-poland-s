import UIKit
import UI
import PLUI
import Commons
import IQKeyboardManagerSwift

protocol PLUnrememberedLoginMaskedPwdViewProtocol: AnyObject, PLLoadingLoginViewCapable, ChangeEnvironmentViewCapable {
    func resetForm()
    func setUserIdentifier(_ identifier: String)
    func setUserImage(image: UIImage)
}

final class PLUnrememberedLoginMaskedPwdViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLUnrememberedLoginMaskedPwdPresenterProtocol
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var regardLabel: UILabel!
    @IBOutlet private weak var documentTextField: PLDocumentTextField!
    @IBOutlet private weak var loginButton: PLLoginButton!
    @IBOutlet weak var environmentButton: UIButton?
    @IBOutlet weak var buttonBottomAnchorConstant: NSLayoutConstraint!
    private lazy var maskedPasswordConstraintWithoutKeyboard: NSLayoutConstraint? = {
        return self.maskedPasswordInputCodeView.topAnchor.constraint(equalTo: self.documentTextField.bottomAnchor, constant: 24)
    }()
    private lazy var maskedPasswordConstraintWithKeyboard: NSLayoutConstraint? = {
        return self.maskedPasswordInputCodeView.bottomAnchor.constraint(equalTo: self.loginButton.topAnchor, constant: -45)
    }()
    private let userImageView = UIImageView()
    private lazy var maskedPasswordInputCodeView: PLUIInputCodeView = {

        let requestedPositions = self.presenter.requestedPositions()

        return PLUIInputCodeView(keyboardType: .default,
                                 delegate: self,
                                 facade: PLUIInputCodeMaskedPasswordFacade(),
                                 elementSize: Constants.makedPasswordBoxSize,
                                 requestedPositions: RequestedPositions.positions(requestedPositions),
                                 charactersSet: Constants.maskedPasswordCharacterSet)
    }()
    private var isShowingKeyboard = false {
        didSet {
            self.maskedPasswordConstraintWithoutKeyboard?.isActive = !isShowingKeyboard
            self.maskedPasswordConstraintWithKeyboard?.isActive = isShowingKeyboard
        }
    }

    private enum Constants {
        static let makedPasswordBoxSize = Screen.isScreenSizeBiggerThanIphone5() ? CGSize(width: 31, height: 56) : CGSize(width: 22, height: 34)
        static let maskedPasswordCharacterSet: CharacterSet = .alphanumerics
        static let bottomDistance: CGFloat = 32
        static let animationDuration: TimeInterval = 0.2
        static let minimumPositionsFulfilled = 8
        static let userImageSize = CGSize(width: 56.0, height: 56.0)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLUnrememberedLoginMaskedPwdPresenterProtocol) {
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

extension PLUnrememberedLoginMaskedPwdViewController: PLUnrememberedLoginMaskedPwdViewProtocol {
    
    func didUpdateEnvironments() {
    }
    
    func resetForm() {
        //TODO: Need to add a reset for PLUIInputCodeView
    }
    
    @IBAction func didSelectChooseEnvironment(_ sender: Any) {
        self.chooseEnvironment()
    }
    
    func chooseEnvironment() {
        self.presenter.didSelectChooseEnvironment()
    }

    func setUserIdentifier(_ identifier: String) {
        self.documentTextField.setText(identifier)
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

private extension PLUnrememberedLoginMaskedPwdViewController {
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
        configureMaskedPasswordInputView()
        configureUserImage()
        configureButtons()
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
        self.documentTextField.isUserInteractionEnabled = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
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

    func configureMaskedPasswordInputView() {

        self.view.addSubview(self.maskedPasswordInputCodeView)
        self.maskedPasswordConstraintWithoutKeyboard?.isActive = true
        NSLayoutConstraint.activate([
            self.maskedPasswordInputCodeView.leadingAnchor.constraint(equalTo: self.documentTextField.leadingAnchor),
            self.maskedPasswordInputCodeView.trailingAnchor.constraint(equalTo: self.documentTextField.trailingAnchor)
        ])
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
    }
    
    func regardNow() -> String {
        return localized(TimeImageAndGreetingViewModel().greetingTextKey.rawValue).plainText
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func configureKeyboard() {
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func loginButtonDidPressed() {
        self.view.endEditing(true)
        let text = self.maskedPasswordInputCodeView.fulfilledText()
        self.presenter.login(password: text ?? "")
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard self.isShowingKeyboard == false else { return }
        self.isShowingKeyboard = true

        guard  let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame: CGRect = keyboardFrameValue.cgRectValue
        buttonBottomAnchorConstant.constant = -keyboardFrame.height - Constants.bottomDistance
        if let loginButton = loginButton {
            view.bringSubviewToFront(loginButton)
        }
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.regardLabel?.alpha = 0.0
            self?.documentTextField?.alpha = 0.0
            self?.userImageView.alpha = 0.0
            self?.view.layoutSubviews()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.isShowingKeyboard = false
        buttonBottomAnchorConstant.constant = -Constants.bottomDistance
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.regardLabel?.alpha = 1.0
            self?.documentTextField?.alpha = 1.0
            self?.userImageView.alpha = self?.userImageView.image != nil ? 1.0 : 0.0
            self?.view.layoutSubviews()
        }
    }
    
    func recoverPasswordOrNewRegistration() {
        self.presenter.recoverPasswordOrNewRegistration()
    }
}

extension PLUnrememberedLoginMaskedPwdViewController: RememberMeViewDelegate {
    func checkButtonPressed() {
        self.view.endEditing(true)
    }
}

extension  PLUnrememberedLoginMaskedPwdViewController: PLUIInputCodeViewDelegate {

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
