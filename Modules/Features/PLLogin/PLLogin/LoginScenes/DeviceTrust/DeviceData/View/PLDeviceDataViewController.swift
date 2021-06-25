//
//  PLDeviceDataViewController.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 17/6/21.
//

import UIKit
import UI
import PLUI
import Commons

protocol PLDeviceDataViewProtocol: AnyObject {
    func addDeviceConfiguration(_ deviceConfiguration: TrustedDeviceConfiguration)
}

final class PLDeviceDataViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLDeviceDataPresenterProtocol

    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var modelDeviceLabel: UILabel!
    @IBOutlet private weak var modelDeviceValueLabel: UILabel!
    @IBOutlet private weak var brandDeviceLabel: UILabel!
    @IBOutlet private weak var brandDeviceValueLabel: UILabel!
    @IBOutlet private weak var idDeviceLabel: UILabel!
    @IBOutlet private weak var idDeviceValueLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLDeviceDataPresenterProtocol) {
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

extension PLDeviceDataViewController: PLDeviceDataViewProtocol {

    func addDeviceConfiguration(_ deviceConfiguration: TrustedDeviceConfiguration) {

        modelDeviceValueLabel.text = deviceConfiguration.model
        brandDeviceValueLabel.text = deviceConfiguration.brand
        idDeviceValueLabel.text = deviceConfiguration.deviceId
    }
}

private extension PLDeviceDataViewController {
    func setupViews() {
        commonInit()
    }

    func commonInit() {
        sanIconImageView?.image = Assets.image(named: "icnSanRedComplete")
        configureLabels()
        configureButtons()
        setAccessibility()
    }

    func configureLabels() {
        titleLabel.font = .santander(family: .text, size: 48)
        titleLabel.textColor = UIColor.Legacy.uiBlack
        titleLabel.configureText(withKey: "pl_onboarding_title_appActiveHello", andConfiguration: nil)
        titleLabel.numberOfLines = 3
        descriptionLabel.font = .santander(family: .text, size: 24)
        descriptionLabel.textColor = UIColor.Legacy.uiBlack
        descriptionLabel.configureText(withKey: "pl_onboarding_text_appActiveWelcome", andConfiguration: nil)
        descriptionLabel.numberOfLines = 5
        modelDeviceLabel.font = .santander(family: .text, type: .light, size: 16)
        modelDeviceLabel.textColor = UIColor.Legacy.uiBlack
        modelDeviceLabel.text = localized("pl_onboarding_text_phoneModel")
        modelDeviceValueLabel.font = .santander(family: .text, type: .bold, size: 16)
        modelDeviceValueLabel.textColor = UIColor.Legacy.uiBlack
//        let deviceName = UIDevice.current.getDeviceName().components(separatedBy: " ")
//        modelDeviceValueLabel.text = deviceName[1]
        brandDeviceLabel.font = .santander(family: .text, type: .light, size: 16)
        brandDeviceLabel.textColor = UIColor.Legacy.uiBlack
        brandDeviceLabel.text = localized("pl_onboarding_text_phoneBrand")
        brandDeviceValueLabel.font = .santander(family: .text, type: .bold, size: 16)
        brandDeviceValueLabel.textColor = UIColor.Legacy.uiBlack
//        brandDeviceValueLabel.text = UIDevice.current.model
        idDeviceLabel.font = .santander(family: .text, type: .light, size: 16)
        idDeviceLabel.textColor = UIColor.Legacy.uiBlack
        idDeviceLabel.text = localized("pl_onboarding_text_phoneID")
        idDeviceValueLabel.font = .santander(family: .text, type: .bold, size: 16)
        idDeviceValueLabel.textColor = UIColor.Legacy.uiBlack
//        idDeviceValueLabel.text = PLLoginTrustedDeviceHelpers.secureRandom(bytesNumber: 9)?.toHexString()
    }

    func configureButtons() {
        continueButton.set(localizedStylableText: localized("generic_button_continue"), state: .normal)
        continueButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        continueButton.backgroundColor = UIColor.santanderRed
        continueButton.layer.cornerRadius = (continueButton?.frame.height ?? 0.0) / 2.0
        continueButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 18.0)
        continueButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(continueButtonDidPressed)))
    }

    func setAccessibility() {
        continueButton.accessibilityIdentifier = AccessibilityUnrememberedLogin.btnEnter.rawValue
    }

    @objc func continueButtonDidPressed() {
        self.presenter.registerDevice()
    }
}