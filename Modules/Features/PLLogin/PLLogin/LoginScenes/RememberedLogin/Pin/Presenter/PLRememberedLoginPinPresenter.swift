//
//  PLRememberedLoginPinPresenter.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/9/21.
//

import Foundation
import Commons
import LoginCommon
import PLCommons
import Models
import LocalAuthentication
import Dynatrace

protocol PLRememberedLoginPinPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLRememberedLoginPinViewControllerProtocol? { get set }
    var loginConfiguration:RememberedLoginConfiguration { get set }
    func viewDidLoad()
    func viewDidAppear()
    func doLogin(with accessType: AccessType)
    func didSelectBalance()
    func didSelectBlik()
    func didSelectMenu()
    func getBiometryTypeAvailable() -> BiometryTypeEntity
    func setAllowLoginBlockedUsers()
    func startBiometricAuth()
    func trackView()
    func trackChangeLoginTypeButton()
}

final class PLRememberedLoginPinPresenter: SafetyCurtainDoorman {
    internal let dependenciesResolver: DependenciesResolver
    weak var view: PLRememberedLoginPinViewControllerProtocol?
    public var loginConfiguration:RememberedLoginConfiguration
    private let localAuth: LocalAuthenticationPermissionsManagerProtocol
    private var allowLoginBlockedUsers = true

    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }
    
    private var loginProcessUseCase: PLRememberedLoginProcessUseCase {
        self.dependenciesResolver.resolve(for: PLRememberedLoginProcessUseCase.self)
    }

    private var sessionUseCase: PLSessionUseCase {
        self.dependenciesResolver.resolve(for: PLSessionUseCase.self)
    }

    private var globalPositionOptionUseCase: PLGetGlobalPositionOptionUseCase {
        return self.dependenciesResolver.resolve(for: PLGetGlobalPositionOptionUseCase.self)
    }

    private var notificationGetTokenAndRegisterUseCase: PLGetNotificationTokenAndRegisterUseCase {
        return self.dependenciesResolver.resolve(for: PLGetNotificationTokenAndRegisterUseCase.self)
    }
    
    var coordinator: PLRememberedLoginPinCoordinator {
        return self.dependenciesResolver.resolve(for: PLRememberedLoginPinCoordinator.self)
    }

    init(dependenciesResolver: DependenciesResolver, configuration: RememberedLoginConfiguration) {
        self.dependenciesResolver = dependenciesResolver
        self.localAuth = dependenciesResolver.resolve(for: LocalAuthenticationPermissionsManagerProtocol.self)
        self.loginConfiguration = configuration
    }
}

extension PLRememberedLoginPinPresenter : PLRememberedLoginPinPresenterProtocol {

    func trackView() {
        self.trackScreen()
    }

    func trackChangeLoginTypeButton() {
        if self.view?.currentLoginType == PLRememberedLoginType.PIN {
            self.trackEvent(.clickBiometric)
        }
        else {
            self.trackEvent(.clickPin)
        }
    }

    func evaluateLoginResult(configuration: RememberedLoginConfiguration,
                             error: UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>?) {
    
        guard configuration.isDemoUser == false else {
            self.loginSuccess()
            return
        }
        
        guard allowLoginBlockedUsers else {
            self.view?.showAccountTemporaryBlockedDialog(configuration)
            return
        }
        
        let time = Date(timeIntervalSince1970: configuration.unblockRemainingTimeInSecs ?? 0)
        if let authType = configuration.challenge?.authorizationType, authType != .softwareToken {
            self.view?.showDeviceConfigurationErrorDialog(completion: { [weak self] in
                self?.coordinator.loadUnrememberedLogin()
            })
        } else if configuration.isFinal() {
            self.view?.showInvalidSCADialog()
        } else if configuration.isBlocked() && time > Date() {
            self.trackEvent(.userTemporarilyBlocked)
            self.allowLoginBlockedUsers = false
            self.view?.showAccountTemporaryBlockedDialog(configuration)
        } else if let err = error {
            let httpErrorCode = self.getHttpErrorCode(err) ?? ""
            self.trackEvent(.apiError, parameters: [PLLoginTrackConstants.errorCode : httpErrorCode, PLLoginTrackConstants.errorDescription : err.getErrorDesc() ?? ""])
            self.handleError(err)
        } else {
            self.loginSuccess()
        }
    }
    
    func loginSuccess() {
        if self.view?.currentLoginType == PLRememberedLoginType.PIN {
            self.trackLoginSuccessWithPin()
        } else {
            self.trackLoginSuccessWithBiometryType()
        }
        self.openSessionAndNavigateToGlobalPosition()
        self.notificationGetTokenAndRegisterUseCase.executeUseCase {}
    }

    func trackLoginSuccessWithPin() {
        self.trackEvent(.loginSuccess, parameters: [PLLoginTrackConstants.loginType : PLLoginTrackConstants.pin])
    }

    func trackLoginSuccessWithBiometryType() {
        switch self.getBiometryTypeAvailable() {
        case .touchId: self.trackEvent(.loginSuccess, parameters: [PLLoginTrackConstants.loginType : PLLoginTrackConstants.touchID])
        case .faceId: self.trackEvent(.loginSuccess, parameters: [PLLoginTrackConstants.loginType : PLLoginTrackConstants.faceID])
        case .none: self.trackLoginSuccessWithPin()
        case .error(biometry: _, error: let error):
            self.trackEvent(.info, parameters: [PLLoginTrackConstants.errorCode: "1040", PLLoginTrackConstants.errorDescription: error.localizedDescription])
        }
    }
   
    func setAllowLoginBlockedUsers() {
        self.allowLoginBlockedUsers = true
    }
    
    func startBiometricAuth() {
        safetyCurtainSafeguardEventWillBegin()
        let type = getBiometryTypeAvailable()
        guard type != .none else {
            self.biometryFails()
            return
        }
        let reasonKey = "pl_login_text_" + (type == .faceId ? "loginWithFaceID" : "loginWithTouchID")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: localized(reasonKey)) { [weak self] success, error in
                DispatchQueue.main.async {
                    if success {
                        self?.biometrySuccess()
                    } else {
                        self?.biometryFails(error: error)
                    }
                }
            }
        }
    }
    
    func getBiometryTypeAvailable() -> BiometryTypeEntity {
        guard loginConfiguration.isBiometricsAvailable else { return .none }
        return self.localAuth.biometryTypeAvailable
    }
    
    func didSelectBalance() {
        
    }

    func didSelectBlik() {
        self.trackEvent(.clickBlik)
    }

    func doLogin(with accessType: AccessType) {
        self.view?.showLoading()
        let config = coordinator.loginConfiguration
        self.loginProcessUseCase.executePersistedLogin(configuration: config, accessType: accessType) { [weak self] config in
            self?.view?.dismissLoading(completion: { [weak self] in
                self?.evaluateLoginResult(configuration: config, error: nil)
            })
        } onFailure: { [weak self]  error, config in
            self?.view?.dismissLoading(completion: { [weak self] in
                self?.evaluateLoginResult(configuration: config, error: error)
            })
        }
    }
    
    func viewDidLoad() {
        self.trackScreen()
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func viewDidAppear() {
        guard let aName = self.loginConfiguration.userPref?.name else { return }
        view?.setUserName(aName)
    }

    func identifyUser(_ userId: String?) {
        Dynatrace.identifyUser(userId)
    }
}

private extension PLRememberedLoginPinPresenter {
    func openSessionAndNavigateToGlobalPosition() {
        Scenario(useCase: self.sessionUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: { [weak self] _ -> Scenario<Void, GetGlobalPositionOptionUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                return Scenario(useCase: self.globalPositionOptionUseCase)
            })
            .onSuccess( { [weak self] output in
                self?.identifyUser(output.userId)
                self?.coordinator.goToGlobalPositionScene(output.globalPositionOption)
            })
            .onError { [weak self] _ in
                self?.coordinator.goToGlobalPositionScene(.classic)
            }
    }
    
    func biometryFails(error: Error? = nil) {
        safetyCurtainSafeguardEventDidFinish()
        
        self.trackEvent(.apiError, parameters: [PLLoginTrackConstants.errorCode : "401",
                                                PLLoginTrackConstants.errorDescription : localized("pl_login_alert_loginError")])
        guard let laError = error as? LAError else {
            self.view?.showUnauthorizedError()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            switch laError.code {
            case .userFallback:
                self?.view?.tryPinAuth()
            case .userCancel:
                break
            default:
                self?.view?.showUnauthorizedError()
            }
        }
    }
    
    func biometrySuccess() {
        safetyCurtainSafeguardEventDidFinish()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.doLogin(with: .biometrics)
        }
    }
    
    @objc func didBecomeActive() {
        view?.applicationDidBecomeActive(for: self.getBiometryTypeAvailable())
    }
}

extension PLRememberedLoginPinPresenter: PLPublicMenuPresentableProtocol {
    func didSelectMenu() {
        self.coordinatorDelegate.didSelectMenu()
    }
}

extension PLRememberedLoginPinPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        //No need to navigate back.
    }
    
    func handle(error: PLGenericError) {
        switch error {
        case .other(let description):
            switch description {
            case "TEMPORARY_LOCKED":
                self.view?.dismissLoading(completion: { [weak self] in
                    self?.trackEvent(.userPermanentlyBlocked)
                    self?.view?.showAccountPermanentlyBlockedDialog()
                })
                return
            default:
                break
            }
        default:
            break
        }
        self.view?.dismissLoading(completion: { [weak self] in
            self?.view?.showUnauthorizedError()
        })

    }
}

extension PLRememberedLoginPinPresenter: AutomaticScreenActionTrackable {
    var trackerManager: TrackerManager {
        return self.dependenciesResolver.resolve(for: TrackerManager.self)
    }

    var trackerPage: PLRememberedLoginPage {
        if self.view?.currentLoginType == PLRememberedLoginType.PIN {
            return PLRememberedLoginPage(PLRememberedLoginPage.pin)
        }
        else {
            return PLRememberedLoginPage(PLRememberedLoginPage.biometric)
        }
    }
}
