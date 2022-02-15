import UI
import CoreFoundationLib
import PLUI
import PLCommons

protocol SmsConfirmationView: AnyObject, LoaderPresentable, ErrorPresentable {}

final class SmsConfirmationViewController: UIViewController, SmsConfirmationView {
    
    private enum Constants {
        static let smsBoxSize = Screen.isScreenSizeBiggerThanIphone5() ? CGSize(width: 45.0, height: 56.0) : CGSize(width: 34, height: 49)
        static let smsCharacterSet: CharacterSet = .decimalDigits
        static let minimumPositionsFulfilled = 6
        static let bottomDistance: CGFloat = -23
    }
    
    private let smsInfoLabel = UILabel()
    private let securityLockIcon = UIImageView()
    private let okButton = LisboaButton()
    private let separatorView = UIView()
    private lazy var smsTextField: PLUIInputCodeView = PLUIInputCodeView(keyboardType: .numberPad,
                                                                             delegate: self,
                                                                             facade: PLUIInputCodeSMSFacade(facadeStyle: .whiteBackground),
                                                                             elementSize: Constants.smsBoxSize,
                                                                             requestedPositions: .all,
                                                                             charactersSet: Constants.smsCharacterSet)
    private var okButtonBottomConstraint: CGFloat = 0
    
    private lazy var okButtonConstraintWithoutKeyboard: NSLayoutConstraint? = {
        return okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.bottomDistance)
    }()
    
    private lazy var okButtonConstraintWithKeyboard: NSLayoutConstraint? = {
        return okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: okButtonBottomConstraint)
    }()
    
    private let presenter: SmsConfirmationPresenterProtocol
    
    init(
        presenter: SmsConfirmationPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension SmsConfirmationViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        configureTexts()
        configureTargets()
        disableOkButton()
        addKeyboardObserver()
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: "genericToolbar_title_confirmation"))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
    
    func configureSubviews() {
        [securityLockIcon,
        smsInfoLabel,
        smsTextField,
        okButton,
        separatorView].forEach(view.addSubview)
        
        securityLockIcon.translatesAutoresizingMaskIntoConstraints = false
        smsInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        smsTextField.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            securityLockIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            securityLockIcon.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            securityLockIcon.heightAnchor.constraint(equalToConstant: 48),
            
            smsInfoLabel.topAnchor.constraint(equalTo: securityLockIcon.bottomAnchor, constant: 15),
            smsInfoLabel.centerXAnchor.constraint(equalTo: securityLockIcon.centerXAnchor),
            smsInfoLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
            
            smsTextField.topAnchor.constraint(equalTo: smsInfoLabel.bottomAnchor, constant: 19),
            smsTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            smsTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            smsTextField.heightAnchor.constraint(equalToConstant: 56),
            
            okButton.heightAnchor.constraint(equalToConstant: 48),
            okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.bottomDistance),
            
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            separatorView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            separatorView.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -16)
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
        
        smsInfoLabel.textColor = .lisboaGray
        smsInfoLabel.textAlignment = .center
        smsInfoLabel.numberOfLines = 2
        smsInfoLabel.font = .santander(
            family: .text,
            type: .light,
            size: 16
        )
        
        securityLockIcon.image = Images.security_sms_lock
        securityLockIcon.contentMode = .scaleAspectFill
        
        separatorView.backgroundColor = .mediumSkyGray
    }
    
    func configureTexts() {
        smsInfoLabel.text = localized("pl_blik_text_enterSms")
        okButton.setTitle(localized("generic_link_ok"), for: .normal)
    }
    
    func configureTargets() {
        okButton.addAction { [weak self] in
            guard let strongSelf = self, let code = strongSelf.smsTextField.fulfilledText()
            else {
                return
            }
            strongSelf.presenter.didPressSubmit(withCode: code)
        }
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard  let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame: CGRect = keyboardFrameValue.cgRectValue
        okButtonBottomConstraint = -keyboardFrame.height + Constants.bottomDistance
        
        setKeyboardBottomConstraints(isKeyboardVisible: true)
        view.layoutSubviews()
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        setKeyboardBottomConstraints(isKeyboardVisible: false)
        view.layoutSubviews()
    }
    
    private func enableOkButton(isEnable: Bool = true) {
        if isEnable {
            okButton.configureAsRedButton()
        }
        okButton.isEnabled = isEnable
    }
    
    private func disableOkButton() {
        okButton.configureAsWhiteButton()
        okButton.isEnabled = false
    }
    
    private func setKeyboardBottomConstraints(isKeyboardVisible: Bool) {
        okButtonConstraintWithKeyboard?.isActive = isKeyboardVisible
        okButtonConstraintWithoutKeyboard?.isActive = !isKeyboardVisible
    }
}

extension SmsConfirmationViewController: PLUIInputCodeViewDelegate {
    func codeView(_ view: PLUIInputCodeView, didChange string: String, for position: NSInteger) {
        if let first = view.firstEmptyRequested(), first > Constants.minimumPositionsFulfilled {
            disableOkButton()
        } else {
            enableOkButton(isEnable: view.isFulfilled())
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
}
