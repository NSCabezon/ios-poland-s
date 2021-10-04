//
//  PLRememberedLoginPinViewController.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/9/21.
//

import Foundation

import Foundation
import PLCommons
import Commons
import UI
import SANLegacyLibrary
import LocalAuthentication
import PLUI

protocol PLRememberedLoginPinViewControllerProtocol: PLGenericErrorPresentableCapable {
    func showAccountPermanentlyBlockedDialog()
    func showAccountTemporaryBlockedDialog(_ configuration: UnrememberedLoginConfiguration)
}

final class PLRememberedLoginPinViewController: UIViewController {
    
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLRememberedLoginPinPresenterProtocol
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var numberPadView: NumberPadView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var pinTextField: UITextField!
    @IBOutlet private weak var balanceButton: UIButton!
    @IBOutlet private weak var biometrySmallButton: UIButton!
    @IBOutlet private weak var biometrySmallLabel: UILabel!
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
            .setRightActions(.menu(action: #selector(didSelectMenu)))
            .build(on: self, with: nil)
    }
    
    @objc func didSelectMenu() {
        self.presenter.didSelectMenu()
    }
    
    @objc func didSelectBalanceButton() {
        //self.presenter.didSelectBalance()
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
    
    @objc func didSelectBiometryButton() {
        self.showBiometryAlert()
    }
    
    @objc func didSelectBlikButton() {
        //self.presenter.didSelectBlik()
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
    
    func setupViews() {
        numberPadView.delegate = self
        sanIconImageView?.image = Assets.image(named: "logoSanLogin")
        backgroundImageView.image = TimeImageAndGreetingViewModel().backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
    }
    
    func setupLabels() {
        
        titleLabel.font = .santander(family: .text, type: .light, size: 40)
        titleLabel.textColor = .Legacy.uiWhite
        titleLabel.numberOfLines = 2
        biometrySmallLabel.font = .santander(family: .text, type: .regular, size: 14)
        biometrySmallLabel.textColor = .Legacy.uiWhite
        
        /*
        let stringLoader = dependenciesResolver.resolve(forOptionalType: StringLoader.self)
        guard let titleText: LocalizedStylableText = stringLoader?.getString("pg_title_welcome", [StringPlaceholder(.name, "Paquito")]) else { return }
        let textConfig = LocalizedStylableTextConfiguration(lineHeightMultiple: 0.70)
        titleLabel.configureText(withLocalizedString: titleText, andConfiguration: textConfig)*/
    }
    
    func setupButtons() {
        balanceButton.setImage(Assets.image(named: "icnBalance"), for: .normal)
        balanceButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(didSelectBalanceButton)))
        biometrySmallButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(didSelectBiometryButton)))
        
        blikButton.setTitle(localized("frequentOperative_label_BLIK"), for: .normal)
        blikButton.setImage(Assets.image(named: "icnBlik")?.withRenderingMode(.alwaysOriginal), for: .normal)
        blikButton.backgroundColor = .santanderRed
        blikButton.titleLabel?.font = .santander(family: .text, type: .bold, size: 14)
        blikButton.titleLabel?.textColor = .Legacy.uiWhite
        blikButton.tintColor = .Legacy.uiWhite
        blikButton.roundCorners(corners: .allCorners, radius: blikButton.frame.size.height/2)
        blikButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(didSelectBlikButton)))
    }
    
    func setupBiometry() {
        switch presenter.getBiometryTypeAvailable() {
        case .touchId:
            biometrySmallButton.setImage(Assets.image(named: "smallFingerprint"), for: .normal)
            biometrySmallLabel.text = localized("loginTouchId_alert_title_touchId")
        case .faceId:
            biometrySmallButton.setImage(Assets.image(named: "smallFaceId"), for: .normal)
            biometrySmallLabel.text = localized("loginTouchId_alert_title_faceId")
        case .error(_,_), .none:
            biometrySmallButton.isHidden = true
            biometrySmallLabel.isHidden = true
            break
        }
    }
    
    func showBiometryAlert() {
        let type = presenter.getBiometryTypeAvailable()
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
        presenter.doLogin(with: pin)
    }
}

extension PLRememberedLoginPinViewController: PLRememberedLoginPinViewControllerProtocol {
    
    func showAccountPermanentlyBlockedDialog() {
        PLLoginCommonDialogs.presentGenericDialogWithText(on: self, textKey: "pl_login_alert_userBlocked")
    }
    
    func showAccountTemporaryBlockedDialog(_ configuration: UnrememberedLoginConfiguration) {
        guard let unblockRemainingTimeInSecs = configuration.unblockRemainingTimeInSecs else { return }
        PLDialogTime(dateTimeStamp: unblockRemainingTimeInSecs) { [weak self] allowLogin in
            if allowLogin {
                self?.presenter.setAllowLoginBlockedUsers()
            }
        }.show(in: self)
    }
}
