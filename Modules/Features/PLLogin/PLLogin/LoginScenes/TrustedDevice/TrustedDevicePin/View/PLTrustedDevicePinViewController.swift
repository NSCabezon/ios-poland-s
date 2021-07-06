//
//  PLTrustedDevicePinViewController.swift
//  PLLogin

import UI
import PLUI
import Commons
import Foundation

protocol PLTrustedDevicePinViewProtocol: class {
    func example()
}

final class PLTrustedDevicePinViewController: UIViewController {
    private let presenter: PLTrustedDevicePinPresenterProtocol
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var closeSceneButton: UIButton!
    @IBOutlet weak var sceneTitle: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var pinDescriptionLabel: UILabel!
    @IBOutlet weak var pinTitleLabel: UILabel!
    @IBOutlet weak var repeatPinTitleLabel: UILabel!

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

    func example() {
        //TODO:
    }
}

private extension PLTrustedDevicePinViewController {
    func setupViews() {
        commonInit()
    }

    func commonInit() {
        configureLabels()
        configureButtons()
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
    }

    func configureButtons() {
        continueButton.set(localizedStylableText: localized("generic_button_continue"), state: .normal)
        continueButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        continueButton.backgroundColor = UIColor.santanderRed
        continueButton.layer.cornerRadius = (continueButton?.frame.height ?? 0.0) / 2.0
        continueButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 18.0)
        continueButton.isEnabled = false
        continueButton.backgroundColor = UIColor.lightSanGray
        continueButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(continueButtonDidPressed)))

        closeSceneButton.setImage(Assets.image(named: "icnClose"), for: .normal)
        closeSceneButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonDidPressed)))
    }

    func setAccessibility() {
        continueButton.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnEnter.rawValue
    }

    // MARK: Button actions
    @objc func continueButtonDidPressed() {
       // TODO: Launch pin format validation
    }

    @objc func closeButtonDidPressed() {
       // TODO: Show dialog
    }
}
