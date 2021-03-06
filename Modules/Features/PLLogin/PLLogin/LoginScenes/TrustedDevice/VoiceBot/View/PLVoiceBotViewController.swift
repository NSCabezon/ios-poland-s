//
//  VoiceBotViewController.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 29/7/21.
//

import UI
import PLUI
import CoreFoundationLib
import PLCommons
import Foundation

protocol PLVoiceBotViewProtocol: PLGenericErrorPresentableCapable {
    func setIvrInputCode(_ ivrInputCode: Int)
    func showIVCCallSendedDialog(code: String)
}

final class PLVoiceBotViewController: UIViewController {
    private let presenter: PLVoiceBotPresenterProtocol

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var closeSceneButton: UIButton!
    @IBOutlet weak var sceneTitle: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var initVoiceBotButton: LisboaButton!
    @IBOutlet weak var codeDescriptionLabel: UILabel!
    @IBOutlet weak var codeTextField: LisboaTextField!

    init(nibName: String?, bundle: Bundle?,
         presenter: PLVoiceBotPresenterProtocol) {
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

extension PLVoiceBotViewController: PLVoiceBotViewProtocol {
    func setIvrInputCode(_ ivrInputCode: Int) {
        self.numberLabel.text = String(ivrInputCode)
    }

    func showIVCCallSendedDialog(code: String) {
            
        // TODO: remove this in the future also remove code parameter
        let codeTest = Int(code) != nil ? code : "0111"
        self.codeTextField.setText(codeTest)
        self.continueButton.backgroundColor = .santanderRed
        self.continueButton.isEnabled = true
        // -------
        
        TopAlertController.setup(TopAlertView.self).showAlert(localized("pl_onboarding_alert_IVRcall"),
                                                              alertType: .info, duration: 5.0)
    }
}

private extension PLVoiceBotViewController {
    func setupViews() {
        commonInit()
    }

    func commonInit() {
        configureLabels()
        configureTextFields()
        configureButtons()
        configureGradient()
        configureAccessibilityIdentifiers()
        lockImage.image = PLAssets.image(named: "deviceTrustIVR")
    }

    func configureLabels() {
        self.sceneTitle.font = .santander(family: .text, type: .bold, size: 16)
        self.sceneTitle.textColor = UIColor.Legacy.sanRed
        self.sceneTitle.configureText(withKey: "pl_onboarding_title_IVR", andConfiguration: nil)
        self.descriptionLabel.font = .santander(family: .text, type: .light, size: 16)
        self.descriptionLabel.textColor = UIColor.Legacy.lisboaGrayNew
        self.descriptionLabel.configureText(withKey: "pl_onboarding_text_IVRExpl", andConfiguration: nil)
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.textAlignment = .center
        self.numberLabel.font = .santander(family: .text, type: .bold, size: 32)
        self.numberLabel.textColor = .brownishGray

        self.codeDescriptionLabel.configureText(withKey: "pl_onboarding_text_IVRcode", andConfiguration: nil)
        self.codeDescriptionLabel.font = .santander(family: .text, type: .bold, size: 14)
        self.codeDescriptionLabel.textColor = UIColor.Legacy.lisboaGrayNew
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
        self.codeTextField.setEditingStyle(editingStyle)
        self.codeTextField.setPlaceholder(localized("pl_onboarding_label_IVRcode"))
        self.codeTextField.setStyle(texfieldStyle)
        self.codeTextField.updatableDelegate = self

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    func customizationBlock(_ components: LisboaTextField.CustomizableComponents) {
        components.textField.keyboardType = .numberPad
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func configureButtons() {
        self.continueButton.set(localizedStylableText: localized("generic_button_continue"), state: .normal)
        self.continueButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        self.continueButton.backgroundColor = UIColor.santanderRed
        self.continueButton.layer.cornerRadius = (continueButton?.frame.height ?? 0.0) / 2.0
        self.continueButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 18.0)
        self.continueButton.backgroundColor = UIColor.lightSanGray
        self.continueButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(continueButtonDidPressed)))

        self.closeSceneButton.isEnabled = true
        self.closeSceneButton.setImage(Assets.image(named: "icnClose"), for: .normal)
        self.closeSceneButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonDidPressed)))

        self.initVoiceBotButton.set(localizedStylableText: localized("pl_onboarding_button_call"), state: .normal)
        self.initVoiceBotButton.setTitleColor(UIColor.santanderRed, for: .normal)
        self.initVoiceBotButton.backgroundColor = UIColor.white
        self.initVoiceBotButton.backgroundPressedColor = .lightSanGray
        self.initVoiceBotButton.borderWidth = 1
        self.initVoiceBotButton.borderColor = UIColor.santanderRed
        self.initVoiceBotButton.layer.cornerRadius = (initVoiceBotButton?.frame.height ?? 0.0) / 2.0
        self.initVoiceBotButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 14.0)
        self.initVoiceBotButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(requestIVRCall)))
    }

    private func configureGradient() {
        self.view.applyGradientBackground(colors: [.white, .skyGray])
    }

    func configureAccessibilityIdentifiers() {
        self.continueButton.accessibilityIdentifier = "deviceTrustVoiceBotBtnContinue"
        self.closeSceneButton.accessibilityIdentifier = "deviceTrustVoiceBotBtnClose"
        self.sceneTitle.accessibilityIdentifier = "pl_onboarding_title_IVR"
        self.lockImage.accessibilityIdentifier = "icnChatBot"
        self.descriptionLabel.accessibilityIdentifier = "pl_onboarding_text_IVRExpl"
        self.numberLabel.accessibilityIdentifier = "deviceTrustVoiceBotLabelCode"
        self.initVoiceBotButton.accessibilityIdentifier = "deviceTrustVoiceBotBtnCall"
        self.codeDescriptionLabel.accessibilityIdentifier = "pl_onboarding_text_IVRcode"
        self.codeTextField.accessibilityIdentifier = "deviceTrustVoiceBotLabelFourDigitCode"
    }

    // MARK: Button actions
    @objc func requestIVRCall() {
        self.initVoiceBotButton.setTitleColor(UIColor.white, for: .normal)
        self.initVoiceBotButton.backgroundColor = .lightSanGray
        self.initVoiceBotButton.borderWidth = 0
        self.initVoiceBotButton.isEnabled = false
        presenter.requestIVRCall()
    }
    
    @objc func continueButtonDidPressed() {
        guard let textCode = self.codeTextField.text else { return }
        presenter.setIvrOutputcode(code: textCode)
        presenter.getDevices()
    }

    @objc func closeButtonDidPressed() {
        self.presenter.closeButtonDidPressed()
        PLLoginCommonDialogs.presentCloseDialog(on: self, onCancel: {
        }, onAccept: { [weak self] in
            self?.presenter.goBack()
        })
    }
}

extension PLVoiceBotViewController: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        if self.codeTextField.text?.count == 4 {
            continueButton.backgroundColor = .santanderRed
            continueButton.isEnabled = true
        }
        else {
            continueButton.backgroundColor = .lightSanGray
            continueButton.isEnabled = false
        }
    }
}
