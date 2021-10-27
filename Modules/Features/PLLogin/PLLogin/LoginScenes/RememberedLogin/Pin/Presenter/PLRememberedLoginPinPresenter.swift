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

protocol PLRememberedLoginPinPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLRememberedLoginPinViewControllerProtocol? { get set }
    var loginConfiguration:RememberedLoginConfiguration { get set }
    func viewDidLoad()
    func viewDidAppear()
    func doLogin(with pin: String)
    func didSelectBalance()
    func didSelectBlik()
    func didSelectMenu()
    func getBiometryTypeAvailable() -> BiometryTypeEntity
    func setAllowLoginBlockedUsers()
    func loginSuccess(configuration: RememberedLoginConfiguration)
}

final class PLRememberedLoginPinPresenter {
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
        self.trackEvent(.loginSuccess, parameters: [PLLoginTrackConstants().loginType : "PIN"])
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
            if configuration.challenge?.authorizationType == .softwareToken {
                self.view?.showDeviceConfigurationErrorDialog()
            } else if configuration.isFinal() {
                self.view?.showInvalidSCADialog()
            } else if configuration.isBlocked() && time > now {
                self.trackEvent(.userTemporarilyBlocked)
                self.allowLoginBlockedUsers = false
                self.view?.showAccountTemporaryBlockedDialog(configuration)
            } else {
                //TODO: Login Success
            }
        })
    }
   
    func setAllowLoginBlockedUsers() {
        self.allowLoginBlockedUsers = true
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

    func doLogin(with pin: String) {
        self.view?.showLoading()
        let config = coordinator.loginConfiguration
        self.loginProcessUseCase.executePersistedLogin(configuration: config) { [weak self] newConfiguration in
            guard let self = self else { return }
            self.coordinator.loginConfiguration.challenge = newConfiguration?.challenge
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
        self.associatedErrorView?.presentError(error, completion: { [weak self] in
            self?.genericErrorPresentedWith(error: error)
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
