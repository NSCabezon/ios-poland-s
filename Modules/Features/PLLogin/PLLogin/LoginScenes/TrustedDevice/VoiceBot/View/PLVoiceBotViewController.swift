//
//  VoiceBotViewController.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 29/7/21.
//

import UI
import PLUI
import Commons
import Foundation

protocol PLVoiceBotViewProtocol: AnyObject {
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
    @IBOutlet weak var initVoiceBotButton: UIButton!
    @IBOutlet weak var codeDescriptionLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!

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
        setAccessibility()
        lockImage.image = PLAssets.image(named: "deviceTrustIVR")
    }

    func configureLabels() {
        sceneTitle.font = .santander(family: .text, type: .bold, size: 16)
        sceneTitle.textColor = UIColor.Legacy.sanRed
        sceneTitle.configureText(withKey: "pl_onboarding_title_IVR", andConfiguration: nil)
        descriptionLabel.font = .santander(family: .text, type: .light, size: 16)
        descriptionLabel.textColor = UIColor.Legacy.lisboaGrayNew
        descriptionLabel.configureText(withKey: "pl_onboarding_text_IVRExpl", andConfiguration: nil)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        numberLabel.text = "56"
        numberLabel.font = .santander(family: .text, type: .bold, size: 32)
        numberLabel.textColor = UIColor(red: 114.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)

        codeDescriptionLabel.configureText(withKey: "pl_onboarding_text_IVRcode", andConfiguration: nil)
        codeDescriptionLabel.font = .santander(family: .text, type: .bold, size: 14)
        codeDescriptionLabel.textColor = UIColor.Legacy.lisboaGrayNew
    }

    func configureTextFields() {
        codeTextField.delegate = self
        codeTextField.font = .santander(family: .text, type: .regular, size: 16)
        codeTextField.textColor = UIColor(red: 114.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
        codeTextField.backgroundColor = UIColor.Legacy.sky30
        codeTextField.drawBorder(cornerRadius: 4, color: .mediumSkyGray, width: 1)

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

        initVoiceBotButton.set(localizedStylableText: localized("pl_onboarding_button_call"), state: .normal)
        initVoiceBotButton.clipsToBounds = true
        initVoiceBotButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        initVoiceBotButton.backgroundColor = UIColor.lightSanGray
        initVoiceBotButton.layer.cornerRadius = (initVoiceBotButton?.frame.height ?? 0.0) / 2.0
        initVoiceBotButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 14.0)
        initVoiceBotButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(continueButtonDidPressed)))
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
    }
}

extension PLVoiceBotViewController: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
