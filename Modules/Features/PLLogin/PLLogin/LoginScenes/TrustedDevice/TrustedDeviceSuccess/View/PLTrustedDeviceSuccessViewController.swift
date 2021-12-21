//
//  PLTrustedDeviceSuccessViewController.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 13/8/21.
//

import UI
import PLUI
import Commons
import PLCommons
import Foundation

protocol PLTrustedDeviceSuccessViewProtocol: PLGenericErrorPresentableCapable {
}

final class PLTrustedDeviceSuccessViewController: UIViewController {
    private let presenter: PLTrustedDeviceSuccessPresenterProtocol

    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!

    init(nibName: String?, bundle: Bundle?,
         presenter: PLTrustedDeviceSuccessPresenterProtocol) {
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

extension PLTrustedDeviceSuccessViewController: PLTrustedDeviceSuccessViewProtocol {
}

private extension PLTrustedDeviceSuccessViewController {
    func setupViews() {
        commonInit()
    }

    func commonInit() {
        self.sanIconImageView?.image = Assets.image(named: "icnSantanderBalance")
        self.configureAccessibilityIdentifiers()
        self.configureLabels()
        self.configureButtons()
    }

    func configureLabels() {
        self.titleLabel.font = .santander(family: .text, type: .regular, size: 48)
        self.titleLabel.textColor = .black
        self.titleLabel.configureText(withKey: "pl_onboarding_title_success", andConfiguration: nil)
        self.subTitleLabel.font = .santander(family: .headline, type: .regular, size: 24)
        self.subTitleLabel.textColor = .black
        self.subTitleLabel.configureText(withKey: "pl_onboarding_text_appActive", andConfiguration: nil)
        self.descriptionLabel.font = .santander(family: .text, type: .light, size: 16)
        self.descriptionLabel.textColor = .lisboaGray
        self.descriptionLabel.configureText(withKey: "pl_onboarding_text_appActiveExpl", andConfiguration: nil)
        self.descriptionLabel.numberOfLines = 0
    }

    func configureButtons() {
        self.continueButton.set(localizedStylableText: localized("generic_button_continue"), state: .normal)
        self.continueButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        self.continueButton.backgroundColor = UIColor.santanderRed
        self.continueButton.layer.cornerRadius = (continueButton?.frame.height ?? 0.0) / 2.0
        self.continueButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 18.0)
        self.continueButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(continueButtonDidPressed)))
        self.continueButton.isEnabled = true
    }
    
    func configureAccessibilityIdentifiers() {
        self.sanIconImageView.accessibilityIdentifier = "icnSanRed"
        self.titleLabel.accessibilityIdentifier = "pl_onboarding_title_success"
        self.subTitleLabel.accessibilityIdentifier = "pl_onboarding_text_appActive"
        self.descriptionLabel.accessibilityIdentifier = "pl_onboarding_text_appActiveExpl"
        self.continueButton.accessibilityIdentifier = "deviceTrustSuccessBtnContinue"
    }

    @objc func continueButtonDidPressed() {
        self.presenter.continueButtonDidPressed()
    }
}
