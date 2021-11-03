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

protocol PLRememberedLoginPinPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLRememberedLoginPinViewControllerProtocol? { get set }
    var loginConfiguration:RememberedLoginConfiguration { get set }
    func viewDidLoad()
    func viewDidAppear()
    func doLogin(with rememberedLoginType: RememberedLoginType)
    func didSelectBalance()
    func didSelectBlik()
    func didSelectMenu()
    func getBiometryTypeAvailable() -> BiometryTypeEntity
    func setAllowLoginBlockedUsers()
    func loginSuccess(configuration: RememberedLoginConfiguration)
    func startBiometricAuth()
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
    
    func loginSuccess(configuration: RememberedLoginConfiguration) {
        guard allowLoginBlockedUsers else {
            self.view?.dismissLoading(completion: { [weak self] in
                self?.view?.showAccountTemporaryBlockedDialog(configuration)
            })
            return
        }
        let time = Date(timeIntervalSince1970: configuration.unblockRemainingTimeInSecs ?? 0)
        let now = Date()
        
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            if configuration.challenge?.authorizationType != .softwareToken {
                self.view?.showDeviceConfigurationErrorDialog()
            } else if configuration.isFinal() {
                self.view?.showInvalidSCADialog()
            } else if configuration.isBlocked() && time > now {
                self.trackEvent(.userTemporarilyBlocked)
                self.allowLoginBlockedUsers = false
                self.view?.showAccountTemporaryBlockedDialog(configuration)
            } else {
                self.trackEvent(.loginSuccess, parameters: [PLLoginTrackConstants().loginType : "PIN"])
                self.openSessionAndNavigateToGlobalPosition()
            }
        })
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
        self.trackEvent(.clickBiometric)
        guard loginConfiguration.isBiometricsAvailable else { return .none }
        #if targetEnvironment(simulator)
        return .faceId
        #else
        return self.localAuth.biometryTypeAvailable
        #endif
    }
    
    func didSelectBalance() {
        
    }

    func didSelectBlik() {
        self.trackEvent(.clickBlik)
    }

    func doLogin(with rememberedLoginType: RememberedLoginType) {
        self.view?.showLoading()
        let config = coordinator.loginConfiguration
        self.loginProcessUseCase.executePersistedLogin(configuration: config, rememberedLoginType: rememberedLoginType) { [weak self] newConfiguration in
            guard let self = self else { return }
            guard let newConfig = newConfiguration else {
                self.view?.showUnauthorizedError()
                return
            }
            self.loginSuccess(configuration: newConfig)
        } onFailure: { [weak self]  error in
            self?.handleError(error)
        }
    }
    
    func viewDidLoad() {
        self.trackScreen()
    }
    
    func viewDidAppear() {
        guard let aName = self.loginConfiguration.userPref?.name else { return }
        view?.setUserName(aName)
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
                self?.coordinator.goToGlobalPositionScene(output.globalPositionOption)
            })
            .onError { [weak self] _ in
                self?.coordinator.goToGlobalPositionScene(.classic)
            }
    }
    
    func biometryFails(error: Error? = nil) {
        safetyCurtainSafeguardEventDidFinish()
        guard let laError = error as? LAError, laError.code == .userFallback else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.view?.showUnauthorizedError()
            }
            return
        }
        self.view?.tryPinAuth()
    }
    
    func biometrySuccess() {
        safetyCurtainSafeguardEventDidFinish()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.doLogin(with: .Biometrics)
        }
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

    var trackerPage: PLRememberedLoginPinPage {
        return PLRememberedLoginPinPage()
    }
}
