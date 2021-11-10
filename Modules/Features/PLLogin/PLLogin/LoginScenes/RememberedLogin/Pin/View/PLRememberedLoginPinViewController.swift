//
//  PLRememberedLoginPinViewController.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/9/21.
//

import Foundation
import PLCommons
import Commons
import UI
import SANLegacyLibrary
import PLUI

protocol PLRememberedLoginPinViewControllerProtocol: PLGenericErrorPresentableCapable {
    func showAccountPermanentlyBlockedDialog()
    func showAccountTemporaryBlockedDialog(_ configuration: RememberedLoginConfiguration)
    func showInvalidSCADialog()
    func showDeviceConfigurationErrorDialog(completion: @escaping (() -> Void))
    func showUnauthorizedError()
    func setUserName(_ name: String)
    func tryPinAuth()
    var currentLoginType: PLRememberedLoginType { get set }
}

public enum PLRememberedLoginType {
    case PIN
    case BIOMETRICS
}

final class PLRememberedLoginPinViewController: UIViewController {
    
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLRememberedLoginPinPresenterProtocol
    var currentLoginType: PLRememberedLoginType = .PIN

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var numberPadView: NumberPadView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var pinTextField: UITextField!
    @IBOutlet private weak var balanceButton: UIButton!
    @IBOutlet private weak var changeLoginTypeButton: UIButton!
    @IBOutlet private weak var biometrySmallLabel: UILabel!
    @IBOutlet private weak var biometryCover: UIView!
    @IBOutlet private weak var biometryBigImage: UIImageView!
    @IBOutlet private weak var biometryBigLabel: UILabel!
    @IBOutlet private weak var blikButton: UIButton!

    private enum Constants {
        static let maxNumberOfDigits = 4
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLRememberedLoginPinPresenterProtocol) {
        self.presenter = presenter
        self.dependenciesResolver = dependenciesResolver
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupLabels()
        self.setupButtons()
        self.setupBiometry()
        self.presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter.viewDidAppear()
    }
}

private extension PLRememberedLoginPinViewController {
    
    func setNavigationBar() {
        NavigationBarBuilder(style: .clear(tintColor: .white), title: .none)
//            .setRightActions(.menu(action: #selector(didSelectMenu)))
            .build(on: self, with: nil)
    }
    
    @objc func didSelectMenu() {
        self.presenter.didSelectMenu()
    }
    
    @objc func didSelectBalanceButton() {
        //self.presenter.didSelectBalance()
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
    
    @objc func didSelectChangeLoginTypeButton() {
        self.presenter.trackChangeLoginTypeButton()
        switch currentLoginType {
        case .PIN:
            self.currentLoginType = .BIOMETRICS
            self.presenter.startBiometricAuth()
        case .BIOMETRICS:
            self.currentLoginType = .PIN
        }
        self.configureViewForLoginType()
    }
    
    @objc func didSelectBlikButton() {
        self.presenter.didSelectBlik()
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
    
    func setupViews() {
        numberPadView.delegate = self
        sanIconImageView?.image = Assets.image(named: "logoSanLogin")
        backgroundImageView.image = TimeImageAndGreetingViewModel.shared.getBackground()
        backgroundImageView.contentMode = .scaleAspectFill
    }
    
    func setupLabels() {
        titleLabel.font = .santander(family: .text, type: .light, size: 40)
        titleLabel.textColor = UIColor.Legacy.uiWhite
        titleLabel.numberOfLines = 2
        biometrySmallLabel.font = .santander(family: .text, type: .regular, size: 14)
        biometrySmallLabel.textColor = UIColor.Legacy.uiWhite
        biometryBigLabel.font = .santander(family: .text, type: .regular, size: 16)
        biometryBigLabel.textColor = UIColor.Legacy.uiWhite
    }
    
    func setupButtons() {
        balanceButton.setImage(Assets.image(named: "icnBalance"), for: .normal)
        balanceButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(didSelectBalanceButton)))
        changeLoginTypeButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(didSelectChangeLoginTypeButton)))
        biometryBigImage.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(retryBiometricAuth)))
        
        blikButton.setTitle(localized("frequentOperative_label_BLIK"), for: .normal)
        blikButton.setImage(Assets.image(named: "icnBlik")?.withRenderingMode(.alwaysOriginal), for: .normal)
        blikButton.backgroundColor = .santanderRed
        blikButton.titleLabel?.font = .santander(family: .text, type: .bold, size: 14)
        blikButton.titleLabel?.textColor = UIColor.Legacy.uiWhite
        blikButton.tintColor = UIColor.Legacy.uiWhite
        blikButton.roundCorners(corners: .allCorners, radius: blikButton.frame.size.height/2)
        blikButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(didSelectBlikButton)))
    }
    
    func configureViewForLoginType() {
        switch currentLoginType {
        case .PIN:
            self.numberPadView.isHidden = false
            self.biometryCover.isHidden = true
            self.setupBiometry()
        case .BIOMETRICS:
            self.biometrySmallLabel.text = localized("pl_onboarding_text_enterPIN")
            self.changeLoginTypeButton.setImage(Assets.image(named: "icnKeyboardLogin"), for: .normal)
            self.numberPadView.isHidden = true
            self.biometryCover.isHidden = false
            self.pinTextField.text = ""
            self.configureNumberPadButtons()
        }
        self.presenter.trackView()
    }
    
    func setupBiometry() {
        switch presenter.getBiometryTypeAvailable() {
        case .touchId:
            changeLoginTypeButton.setImage(Assets.image(named: "smallFingerprint"), for: .normal)
            biometryBigImage.image = Assets.image(named: "icnFingerprintLogin")
            biometrySmallLabel.text = localized("loginTouchId_alert_title_touchId")
            biometryBigLabel.text = localized("pl_login_text_loginWithTouchID")
        case .faceId:
            changeLoginTypeButton.setImage(Assets.image(named: "smallFaceId"), for: .normal)
            biometryBigImage.image = Assets.image(named: "icnFaceIdLogin")
            biometrySmallLabel.text = localized("loginTouchId_alert_title_faceId")
            biometryBigLabel.text = localized("pl_login_text_loginWithFaceID")
        case .error(_,_), .none:
            changeLoginTypeButton.isHidden = true
            biometrySmallLabel.isHidden = true
            break
        }
    }
    
    @objc func retryBiometricAuth() {
        self.presenter.startBiometricAuth()
    }
    
    func configureNumberPadButtons() {
        let digits = currentDigits()
        if digits == Constants.maxNumberOfDigits {
            numberPadView.showOkButton()
        } else {
            numberPadView.hideOkButton()
        }
        guard digits > 0 else {
            numberPadView.hideEraseButton()
            return
        }
        numberPadView.showEraseButton()
    }
    
    func currentDigits() -> Int {
        return pinTextField.text?.count ?? 0
    }
}

extension PLRememberedLoginPinViewController: NumberPadViewDelegate {
    func didTapOnNumber(number: Int) {
        guard currentDigits() < Constants.maxNumberOfDigits else { return }
        pinTextField.text = (pinTextField.text ?? "") + String(number)
        configureNumberPadButtons()
    }
    
    func didTapOnErase() {
        pinTextField.text = String((pinTextField.text ?? "").dropLast())
        configureNumberPadButtons()
    }
    
    func didTapOnOK() {
        guard let pin = pinTextField.text else { return }
        presenter.doLogin(with: .Pin(value: pin))
    }
}

extension PLRememberedLoginPinViewController: PLRememberedLoginPinViewControllerProtocol {
    
    func tryPinAuth() {
        self.currentLoginType = .PIN
        self.configureViewForLoginType()
    }
    
    func setUserName(_ name: String) {
        let key = name != "" ? "onboarding_title_hello" : "pg_title_welcome"
        let stringLoader = dependenciesResolver.resolve(forOptionalType: StringLoader.self)
        guard let titleText: LocalizedStylableText = stringLoader?.getString(key, [StringPlaceholder(.name, name)]) else { return }
        let textConfig = LocalizedStylableTextConfiguration(lineHeightMultiple: 0.70)
        titleLabel.configureText(withLocalizedString: titleText, andConfiguration: textConfig)
    }
    
    func showAccountPermanentlyBlockedDialog() {
        PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_userBlocked")
    }
    
    func showDeviceConfigurationErrorDialog(completion: @escaping (() -> Void)) {
        PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_deviceReinstallError", completion: completion)
    }
    
    func showInvalidSCADialog() {
        PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_attemptLast")
    }
    
    func showUnauthorizedError() {
        PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_loginError")
    }
    
    func showAccountTemporaryBlockedDialog(_ configuration: RememberedLoginConfiguration) {
        guard let unblockRemainingTimeInSecs = configuration.unblockRemainingTimeInSecs else { return }
        PLDialogTime(dateTimeStamp: unblockRemainingTimeInSecs) { [weak self] allowLogin in
            if allowLogin {
                self?.presenter.setAllowLoginBlockedUsers()
            }
        }.show(in: self)
    }
}
