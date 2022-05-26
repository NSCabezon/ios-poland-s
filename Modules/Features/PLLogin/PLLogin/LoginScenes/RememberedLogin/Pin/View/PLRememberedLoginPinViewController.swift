//
//  PLRememberedLoginPinViewController.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/9/21.
//

import Foundation
import PLCommons
import CoreFoundationLib
import UI
import SANLegacyLibrary
import PLUI

protocol PLRememberedLoginPinViewControllerProtocol: PLGenericErrorPresentableCapable, ChangeEnvironmentViewCapable {
    func showDialog(_ type: PLRememberedLoginDialogType)
    func setUserName(_ name: String)
    func tryPinAuth(withError: Bool)
    var currentLoginType: PLRememberedLoginType { get set }
    func applicationDidBecomeActive()
}

public enum PLRememberedLoginDialogType {
    case invalidSCA
    case accountTemporarilyBlocked(RememberedLoginConfiguration)
    case accountPermanentlyBlocked
    case unauthorized
    case configurationError(() -> Void)
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
    @IBOutlet private weak var changeUserButton: UIButton!
    @IBOutlet private weak var biometryCover: UIView!
    @IBOutlet private weak var biometryBigImage: UIImageView!
    @IBOutlet private weak var biometryBigLabel: UILabel!
    @IBOutlet private weak var blikButton: UIButton!
    @IBOutlet weak var environmentButton: UIButton?

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
        self.setupEnvironmentButton()
        self.presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter.viewDidAppear()
        self.tryBiometricAuth()
    }
}

private extension PLRememberedLoginPinViewController {
    func setNavigationBar() {
        NavigationBarBuilder(style: .clear(tintColor: .white), title: .none)
            .setRightActions(.menu(action: #selector(didSelectMenu)))
            .build(on: self, with: nil)
    }
    
    func tryBiometricAuth() {
        switch presenter.currentBiometryType {
        case .touchId, .faceId:
            self.configureViewForLogin(type: .BIOMETRICS)
            self.presenter.startBiometricAuth()
        default:
            break
        }
    }
    
    @objc func didSelectMenu() {
        self.presenter.didSelectMenu()
    }
    
    @objc func didSelectBalanceButton() {
        self.presenter.didSelectBalance()
    }
    
    @objc func didSelectChangeUserButton() {
        self.presenter.didSelectChangeUser()
    }
    
    @objc func didSelectChangeLoginTypeButton() {
        self.presenter.trackChangeLoginTypeButton()
        switch self.currentLoginType {
        case .PIN:
            self.configureViewForLogin(type: .BIOMETRICS)
            self.presenter.startBiometricAuth()
        case .BIOMETRICS:
            self.configureViewForLogin(type: .PIN)
        }
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
        changeUserButton.isHidden = true
    }
    
    func setupLabels() {
        titleLabel.font = .santander(family: .text, type: .light, size: 40)
        titleLabel.textColor = UIColor.Legacy.uiWhite
        titleLabel.numberOfLines = 2
        biometryBigLabel.font = .santander(family: .text, type: .regular, size: 16)
        biometryBigLabel.textColor = UIColor.Legacy.uiWhite
    }
    
    func setupButtons() {
        balanceButton.setImage(Assets.image(named: "icnBalance"), for: .normal)
        balanceButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(didSelectBalanceButton)))
        balanceButton.isHidden = !presenter.deviceHasSystemPasscode()
        
        changeLoginTypeButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        changeLoginTypeButton.titleLabel?.font =  .santander(family: .text, type: .regular, size: 14)
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
        changeUserButton.setImage(Assets.image(named: "icnUser"), for: .normal)
        changeUserButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        changeUserButton.titleLabel?.font =  .santander(family: .text, type: .regular, size: 14)
        changeUserButton.titleLabel?.numberOfLines = 1
        changeUserButton.titleLabel?.adjustsFontSizeToFitWidth = true
        changeUserButton.titleLabel?.minimumScaleFactor = 0.5
        changeUserButton.setTitle(localized("loginRegistered_button_changeUser"), for: .normal)
        changeUserButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(didSelectChangeUserButton)))
    }
    
    func configureViewForLogin(type: PLRememberedLoginType) {
        self.currentLoginType = type
        switch self.currentLoginType {
        case .PIN:
            self.numberPadView.isHidden = false
            self.biometryCover.isHidden = true
            self.setupBiometry()
        case .BIOMETRICS:
            self.changeLoginTypeButton.setImage(Assets.image(named: "icnKeyboardLogin"), for: .normal)
            self.changeLoginTypeButton.setTitle(localized("pl_onboarding_text_enterPIN"), for: .normal)
            self.numberPadView.isHidden = true
            self.biometryCover.isHidden = false
            self.pinTextField.text = ""
            self.configureNumberPadButtons()
        }
        self.presenter.trackView()
    }
    
    func setupBiometry() {
        switch presenter.currentBiometryType {
        case .touchId:
            changeLoginTypeButton.setImage(Assets.image(named: "smallFingerprint"), for: .normal)
            changeLoginTypeButton.setTitle(localized("loginTouchId_alert_title_touchId"), for: .normal)
            biometryBigImage.image = Assets.image(named: "icnFingerprintLogin")
            biometryBigLabel.text = localized("pl_login_text_loginWithTouchID")
            changeLoginTypeButton.isHidden = false
        case .faceId:
            changeLoginTypeButton.setImage(Assets.image(named: "smallFaceId"), for: .normal)
            changeLoginTypeButton.setTitle(localized("loginTouchId_alert_title_faceId"), for: .normal)
            biometryBigImage.image = Assets.image(named: "icnFaceIdLogin")
            biometryBigLabel.text = localized("pl_login_text_loginWithFaceID")
            changeLoginTypeButton.isHidden = false
        case .error(_,_), .none:
            changeLoginTypeButton.isHidden = true
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
        presenter.tryToLogin(with: .pin(value: pin))
    }
}

extension PLRememberedLoginPinViewController: PLRememberedLoginPinViewControllerProtocol {
    
    func didUpdateEnvironments() {
    }
    
    @IBAction func didSelectChooseEnvironment(_ sender: Any) {
        self.chooseEnvironment()
    }
    
    func chooseEnvironment() {
        self.presenter.didSelectChooseEnvironment()
    }
    
    func applicationDidBecomeActive() {
        switch presenter.currentBiometryType {
        case .error(biometry: _, error: _), .none:
            self.configureViewForLogin(type: .PIN)
        case .touchId, .faceId:
            self.configureViewForLogin(type: .BIOMETRICS)
            self.tryBiometricAuth()
        }
        self.setupBiometry()
    }
    
    func tryPinAuth(withError: Bool) {
        if withError {
            let textStyle = LocalizedStylableText(text: localized("pl_login_alert_lastBiometricAttempt"), styles: nil)
            TopAlertController.setup(TopAlertView.self).showAlert(textStyle, alertType: .failure, duration: 5.0)
        }
        self.configureViewForLogin(type: .PIN)
    }
    
    func setUserName(_ name: String) {
        let key = name != "" ? "onboarding_title_hello" : "pg_title_welcome"
        let stringLoader = dependenciesResolver.resolve(forOptionalType: StringLoader.self)
        guard let titleText: LocalizedStylableText = stringLoader?.getString(key, [StringPlaceholder(.name, name)]) else { return }
        let textConfig = LocalizedStylableTextConfiguration(lineHeightMultiple: 0.70)
        titleLabel.configureText(withLocalizedString: titleText, andConfiguration: textConfig)
    }
    
    func showAccountTemporaryBlockedDialog(_ configuration: RememberedLoginConfiguration) {
        guard let unblockRemainingTimeInSecs = configuration.unblockRemainingTimeInSecs else { return }
        PLDialogTime(dateTimeStamp: unblockRemainingTimeInSecs) { [weak self] allowLogin in
            if allowLogin {
                self?.presenter.setAllowLoginBlockedUsers()
            }
        }.show(in: self)
    }

    func showDialog(_ type: PLRememberedLoginDialogType) {
        self.dismissLoading {
            switch type {
            case .accountPermanentlyBlocked:
                PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_userBlocked")
            case .accountTemporarilyBlocked(let configuration):
                self.showAccountTemporaryBlockedDialog(configuration)
            case .invalidSCA:
                PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_attemptLast")
            case .unauthorized:
                PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_loginError")
            case .configurationError(let completion):
                PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_deviceReinstallError", completion: completion)
            }
        }
    }
}

extension PLRememberedLoginPinViewController: RootMenuController {
    var isSideMenuAvailable: Bool {
        return true
    }
}
