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
        tokenChallengeValueLabel.text = "29401340"
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
        textFieldFormmater.setMaxLength(maxLength: 4)
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
    }

    @objc func closeButtonDidPressed() {
        let absoluteMargin: (left: CGFloat, right: CGFloat) = (left: 19.0, right: 9.0)
        let onCancel: () -> Void = { }
        let onAccept: () -> Void = { self.presenter.goToDeviceTrustDeviceData() }
        let components: [LisboaDialogItem] = [
            .image(LisboaDialogImageViewItem(image: Assets.image(named: "icnDanger"), size: (70, 70))),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("pl_onboarding_alert_PINQuitTitle"),
                    font: .santander(family: .text, type: .bold, size: 28),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(12.0),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("pl_onboarding_alert_PINQuitText"),
                    font: .santander(family: .text, type: .light, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(24.0),
            .horizontalActions(
                HorizontalLisboaDialogActions(
                    left: LisboaDialogAction(title: localized("generic_link_no"),
                                             type: .white,
                                             margins: absoluteMargin,
                                             action: onCancel),
                    right: LisboaDialogAction(title: localized("generic_link_yes"),
                                              type: .red,
                                              margins: absoluteMargin,
                                              action: onAccept))),
            .margin(16.0)
        ]
        let builder = LisboaDialog(items: components, closeButtonAvailable: true)
        builder.showIn(self)
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
        if self.tokenResponseValueTextField.text?.count == 8 {
            continueButton.backgroundColor = .santanderRed
            continueButton.isEnabled = true
        }
        else {
            continueButton.backgroundColor = .lightSanGray
            continueButton.isEnabled = false
        }
    }
}
