//
//  PLTrustedDeviceHardwareTokenViewController.swift
//  PLLogin

import UI
import PLUI
import Commons
import PLCommons
import Foundation
import IQKeyboardManagerSwift

protocol PLTrustedDeviceHardwareTokenViewProtocol: PLGenericErrorPresentableCapable {
    func showChallenge(challenge: String)
    func showAuthErrorDialog()
}

final class PLTrustedDeviceHardwareTokenViewController: UIViewController {
    private let presenter: PLTrustedDeviceHardwareTokenPresenterProtocol

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var closeSceneButton: UIButton!
    @IBOutlet weak var sceneTitle: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tokenChallengeTitleLabel: UILabel!
    @IBOutlet weak var tokenChallengeValueLabel: UILabel!
    @IBOutlet weak var tokenResponseTitleLabel: UILabel!
    @IBOutlet weak var tokenResponseValueTextField: LisboaTextField!
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
        static let bottomDistance: CGFloat = 32
        static let animationDuration: TimeInterval = 0.2
        static let tokenDigits: Int = 8
    }

    init(nibName: String?, bundle: Bundle?,
         presenter: PLTrustedDeviceHardwareTokenPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        self.setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardObserver()
    }
}

extension PLTrustedDeviceHardwareTokenViewController: PLTrustedDeviceHardwareTokenViewProtocol {
    func showAuthErrorDialog() {
        self.presentError((titleKey: "pl_onboarding_alert_authFailedTitle",
                           descriptionKey: "pl_onboarding_alert_authFailedText")) { [weak self] in
            self?.presenter.goToDeviceTrustDeviceData()
        }
    }
    
    func showChallenge(challenge: String) {
        self.tokenChallengeValueLabel.text = challenge
    }
}

private extension PLTrustedDeviceHardwareTokenViewController {
    func setupViews() {
        commonInit()
    }

    func commonInit() {
        configureLabels()
        configureTextFields()
        configureButtons()
        configureGradient()
        setAccessibility()
        lockImage.image = PLAssets.image(named: "threeDigitsRedLockIcon")
    }

    func configureLabels() {
        sceneTitle.font = .santander(family: .text, type: .bold, size: 16)
        sceneTitle.textColor = UIColor.Legacy.sanRed
        sceneTitle.configureText(withKey: "pl_onboarding_title_token", andConfiguration: nil)
        descriptionLabel.font = .santander(family: .text, type: .light, size: 16)
        descriptionLabel.textColor = UIColor.Legacy.lisboaGrayNew
        descriptionLabel.configureText(withKey: "pl_onboarding_text_tokenExpl", andConfiguration: nil)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        tokenChallengeTitleLabel.font = .santander(family: .text, type: .bold, size: 14)
        tokenChallengeTitleLabel.textColor = UIColor.Legacy.lisboaGrayNew
        tokenChallengeTitleLabel.configureText(withKey: "pl_onboarding_text_tokenChallenge", andConfiguration: nil)
        tokenChallengeValueLabel.font = .santander(family: .text, type: .bold, size: 32)
        tokenChallengeValueLabel.textColor = UIColor.brownishGray
        tokenResponseTitleLabel.font = .santander(family: .text, type: .bold, size: 14)
        tokenResponseTitleLabel.textColor = UIColor.Legacy.lisboaGrayNew
        tokenResponseTitleLabel.configureText(withKey: "pl_onboarding_text_tokenResp", andConfiguration: nil)
        tokenResponseTitleLabel.numberOfLines = 0
        tokenResponseTitleLabel.textAlignment = .center
    }

    func configureTextFields() {
        var texfieldStyle: LisboaTextFieldStyle {
            var style = LisboaTextFieldStyle.default
            style.titleLabelFont = .santander(family: .text, type: .regular, size: 16)
            style.titleLabelTextColor = .brownishGray
            style.fieldFont = .santander(family: .text, type: .regular, size: 16)
            style.fieldTextColor = .lisboaGray
            style.containerViewBackgroundColor = .skyGray
            return style
        }

        let textFieldFormmater = UIFormattedCustomTextField()
        textFieldFormmater.setMaxLength(maxLength: Constants.tokenDigits)
        textFieldFormmater.setAllowOnlyCharacters(.decimalDigits)
        let configuration = LisboaTextField.WritableTextField(type: .floatingTitle,
                                                              formatter: textFieldFormmater,
                                                              disabledActions: [.paste],
                                                              keyboardReturnAction: nil,
                                                              textfieldCustomizationBlock: self.customizationBlock(_:))

        let editingStyle = LisboaTextField.EditingStyle.writable(configuration: configuration)
        self.tokenResponseValueTextField.setEditingStyle(editingStyle)
        self.tokenResponseValueTextField.setPlaceholder(localized("pl_onboarding_label_token"))
        self.tokenResponseValueTextField.setStyle(texfieldStyle)
        self.tokenResponseValueTextField.updatableDelegate = self

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    func customizationBlock(_ components: LisboaTextField.CustomizableComponents) {
        components.textField.keyboardType = .numberPad
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func configureButtons() {
        continueButton.set(localizedStylableText: localized("generic_button_continue"), state: .normal)
        continueButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        continueButton.backgroundColor = UIColor.santanderRed
        continueButton.layer.cornerRadius = (continueButton?.frame.height ?? 0.0) / 2.0
        continueButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 18.0)
        continueButton.backgroundColor = UIColor.lightSanGray
        continueButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(continueButtonDidPressed)))

        closeSceneButton.isEnabled = true
        closeSceneButton.setImage(Assets.image(named: "icnClose"), for: .normal)
        closeSceneButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonDidPressed)))
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

    private func configureGradient() {
        self.view.applyGradientBackground(colors: [.white, .skyGray])
    }

    func setAccessibility() {
        continueButton.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnEnter.rawValue
    }

    // MARK: Button actions
    @objc func continueButtonDidPressed() {
        guard let code = self.tokenResponseValueTextField.text else {
            return
        }
        self.presenter.registerConfirm(code: code)
    }

    @objc func closeButtonDidPressed() {
        self.presenter.closeButtonDidPressed()
        PLLoginCommonDialogs.presentCloseDialog(on: self, onCancel: {
        }, onAccept: { [weak self] in
            self?.presenter.goToDeviceTrustDeviceData()
        })
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard self.isShowingKeyboard == false else { return }
        self.isShowingKeyboard = true

        guard  let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame: CGRect = keyboardFrameValue.cgRectValue
        buttonBottomAnchorConstraint.constant = -keyboardFrame.height - Constants.bottomDistance
        if let loginButton = continueButton {
            view.bringSubviewToFront(loginButton)
        }
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.descriptionLabel?.alpha = 0.0
            self?.lockImage?.alpha = 0.0
            self?.view.layoutSubviews()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.isShowingKeyboard = false
        buttonBottomAnchorConstraint.constant = -Constants.bottomDistance
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.descriptionLabel?.alpha = 1.0
            self?.lockImage?.alpha = 1.0
            self?.view.layoutSubviews()
        }
    }
}

extension PLTrustedDeviceHardwareTokenViewController: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        if self.tokenResponseValueTextField.text?.count == Constants.tokenDigits {
            continueButton.backgroundColor = .santanderRed
            continueButton.isEnabled = true
            view.endEditing(true)
        } else {
            continueButton.backgroundColor = .lightSanGray
            continueButton.isEnabled = false
        }
    }
}
