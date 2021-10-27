//
//  PLTrustedDevicePinViewController.swift
//  PLLogin

import UI
import PLUI
import Commons
import PLCommons
import Foundation

protocol PLTrustedDevicePinViewProtocol: PLGenericErrorPresentableCapable {
}

final class PLTrustedDevicePinViewController: UIViewController {
    private let presenter: PLTrustedDevicePinPresenterProtocol
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var closeSceneButton: UIButton!
    @IBOutlet weak var sceneTitle: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var pinDescriptionLabel: UILabel!
    @IBOutlet weak var pinTitleLabel: UILabel!
    @IBOutlet weak var pinContainerView: UIView!
    @IBOutlet weak var repeatPinTitleLabel: UILabel!
    @IBOutlet weak var repeatPinContainerView: UIView!
    private var biometryInfoView: PLUIInteractiveInfoView?
    private var pinInputComplete: Bool = false
    private var repeatPinInputComplete: Bool = false
    private var shouldCreateBiometricToken: Bool = false
    private lazy var shouldAddBiometryView: Bool = {
        return self.presenter.shouldShowBiometry()
    }()

    private lazy var pinInputCodeView = PLUIInputCodeView(keyboardType: .numberPad,
                                                                             delegate: self,
                                                                             facade: PLUIInputCodePinFacade(),
                                                                             elementSize: Constants.pinBoxSize,
                                                                             requestedPositions: .all,
                                                                             charactersSet: Constants.pinCharacterSet)

    private lazy var repeatPinInputCodeView = PLUIInputCodeView(keyboardType: .numberPad,
                                                                             delegate: self,
                                                                             facade: PLUIInputCodePinFacade(),
                                                                             elementSize: Constants.pinBoxSize,
                                                                             requestedPositions: .all,
                                                                             charactersSet: Constants.pinCharacterSet)

    private enum Constants {
        static let pinBoxSize =	 CGSize(width: 55.0, height: 56.0)
        static let pinCharacterSet: CharacterSet = .decimalDigits
    }

    init(nibName: String?, bundle: Bundle?,
         presenter: PLTrustedDevicePinPresenterProtocol) {
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
    }
}

extension PLTrustedDevicePinViewController: PLTrustedDevicePinViewProtocol {
}

private extension PLTrustedDevicePinViewController {
    func setupViews() {
        commonInit()
    }

    func commonInit() {
        configureLabels()
        configureButtons()
        configurePinView()
        configureBiometryView()
        configureGradient()
        setAccessibility()
        lockImage.image = PLAssets.image(named: "threeDigitsRedLockIcon")
    }

    func configureLabels() {
        sceneTitle.font = .santander(family: .text, type: .bold, size: 16)
        sceneTitle.textColor = UIColor.Legacy.sanRed // TODO: Review this color code
        sceneTitle.configureText(withKey: "pl_onboarding_title_appPIN", andConfiguration: nil)
        pinDescriptionLabel.font = .santander(family: .text, type: .light, size: 16)
        pinDescriptionLabel.textColor = UIColor.Legacy.lisboaGrayNew
        pinDescriptionLabel.configureText(withKey: "pl_onboarding_text_PINExpl", andConfiguration: nil)
        pinDescriptionLabel.numberOfLines = 0
        pinDescriptionLabel.textAlignment = .center
        pinTitleLabel.font = .santander(family: .micro, type: .bold, size: 14)
        pinTitleLabel.textColor = UIColor.Legacy.lisboaGrayNew
        pinTitleLabel.configureText(withKey: "pl_onboarding_text_enterPIN", andConfiguration: nil)
        repeatPinTitleLabel.font = .santander(family: .micro, type: .bold, size: 14)
        repeatPinTitleLabel.textColor = UIColor.Legacy.lisboaGrayNew
        repeatPinTitleLabel.configureText(withKey: "pl_onboarding_text_repeatPIN", andConfiguration: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
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

    func configurePinView() {
        self.pinContainerView.addSubview(self.pinInputCodeView)
        self.repeatPinContainerView.addSubview(self.repeatPinInputCodeView)
        NSLayoutConstraint.activate([
            self.pinInputCodeView.leadingAnchor.constraint(equalTo: self.pinContainerView.leadingAnchor),
            self.pinInputCodeView.trailingAnchor.constraint(equalTo: self.pinContainerView.trailingAnchor),
            self.pinInputCodeView.topAnchor.constraint(equalTo: self.pinContainerView.topAnchor),
            self.pinInputCodeView.bottomAnchor.constraint(equalTo: self.pinContainerView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            self.repeatPinInputCodeView.leadingAnchor.constraint(equalTo: self.repeatPinContainerView.leadingAnchor),
            self.repeatPinInputCodeView.trailingAnchor.constraint(equalTo: self.repeatPinContainerView.trailingAnchor),
            self.repeatPinInputCodeView.topAnchor.constraint(equalTo: self.repeatPinContainerView.topAnchor),
            self.repeatPinInputCodeView.bottomAnchor.constraint(equalTo: self.repeatPinContainerView.bottomAnchor)
        ])
    }

    func configureBiometryView() {
        if self.shouldAddBiometryView == true {
            guard let image = PLAssets.image(named: "fingerprint") else { return }
            self.biometryInfoView = PLUIInteractiveInfoView(image: image,
                                                            title: localized("pl_onboarding_text_biometrics"),
                                                            text: localized("pl_onboarding_text_biometricsExpl"))
            self.biometryInfoView?.delegate = self
            if let biometryInfoView = self.biometryInfoView {
                self.contentView.addSubview(biometryInfoView)

                NSLayoutConstraint.activate([
                    biometryInfoView.topAnchor.constraint(equalTo: self.repeatPinContainerView.bottomAnchor, constant: 42),
                    biometryInfoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
                    biometryInfoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15)
                ])
            }
        }
    }

    private func configureGradient() {
        self.view.applyGradientBackground(colors: [.white, .skyGray])
    }

    func setAccessibility() {
        continueButton.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnEnter.rawValue
    }

    // MARK: Button actions
    @objc func continueButtonDidPressed() {
        let regexEqualDigits = #"([0-9])\1{2}"#
        let regexConsecutiveDigits = #"(012|123|234|345|456|567|678|789)"#
        guard let pinInputText = pinInputCodeView.fulfilledText() else { return }
        guard let repeatPinInputText = repeatPinInputCodeView.fulfilledText() else { return }
        if pinInputText.range(of: regexEqualDigits, options: .regularExpression) != nil {
            self.showEqualDigitsDialog()
        }
        else if pinInputText.range(of: regexConsecutiveDigits, options: .regularExpression) != nil {
            self.showConsecutiveDigitsDialog()
        }
        else if !pinInputText.elementsEqual(repeatPinInputText) {
            self.showNotEqualPinDialog()
        }
        else {
            self.presenter.registerSoftwareToken(with: self.shouldCreateBiometricToken, and: pinInputText)
        }
    }

    private func showEqualDigitsDialog() {
        self.presenter.trackInfoEvent(localized("pl_onboarding_alert_PIN3digits"))
        let textStyle: LocalizedStylableText = LocalizedStylableText(text: localized("pl_onboarding_alert_PIN3digits"), styles: [.init(start: 0, length: localized("pl_onboarding_alert_PIN3digits").count, attribute: .color(hex: "444444"))])
        TopAlertController.setup(TopAlertView.self).showAlert(textStyle, alertType: .failure, duration: 5.0)
    }

    private func showConsecutiveDigitsDialog() {
        self.presenter.trackInfoEvent(localized("pl_onboarding_alert_2consequitDigits"))
        let textStyle: LocalizedStylableText = LocalizedStylableText(text: localized("pl_onboarding_alert_2consequitDigits"), styles: [.init(start: 0, length: localized("pl_onboarding_alert_2consequitDigits").count, attribute: .color(hex: "444444"))])
        TopAlertController.setup(TopAlertView.self).showAlert(textStyle, alertType: .failure, duration: 5.0)
    }

    private func showNotEqualPinDialog() {
        self.presenter.trackInfoEvent(localized("pl_onboarding_alert_PINdiffer"))
        let textStyle: LocalizedStylableText = LocalizedStylableText(text: localized("pl_onboarding_alert_PINdiffer"), styles: [.init(start: 0, length: localized("pl_onboarding_alert_PINdiffer").count, attribute: .color(hex: "444444"))])
        TopAlertController.setup(TopAlertView.self).showAlert(textStyle, alertType: .failure, duration: 5.0)
    }

    @objc func closeButtonDidPressed() {
        self.presenter.closeButtonDidPressed()
        PLLoginCommonDialogs.presentCloseDialog(on: self, onCancel: {
        }, onAccept: { [weak self] in
            self?.presenter.goToDeviceTrustDeviceData()
        })
    }
}

extension  PLTrustedDevicePinViewController: PLUIInputCodeViewDelegate {

    func codeView(_ view: PLUIInputCodeView, didChange string: String, for position: NSInteger) {
        if view.isFulfilled() {
            if view == pinInputCodeView {
                self.pinInputComplete = true
            }
            else if view == repeatPinInputCodeView {
                self.repeatPinInputComplete = true
            }
            if pinInputComplete == true && repeatPinInputComplete == true {
                self.continueButton.isEnabled = true
                self.continueButton.backgroundColor = UIColor.santanderRed
            }
        } else {
            self.continueButton.isEnabled = view.isFulfilled()
            self.continueButton.backgroundColor = UIColor.lightSanGray
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
        if view == self.pinInputCodeView && view.isFulfilled() && self.repeatPinInputCodeView.isFulfilled() == false {
            repeatPinInputCodeView.becomeFirstResponder()
        }
    }
}

extension PLTrustedDevicePinViewController: PLUIInteractiveInfoViewDelegate {
    func interactiveInfoView(_: PLUIInteractiveInfoView, didChangeSwitch value: Bool) {
        self.shouldCreateBiometricToken = value
        self.presenter.createBiometricToken(value)
    }
}
