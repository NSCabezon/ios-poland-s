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
    var currentBiometryType: BiometryTypeEntity { get set }
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func doLogin(with accessType: AccessType)
    func didSelectBalance()
    func didSelectBlik()
    func didSelectMenu()
    func didSelectChangeUser()
    func setAllowLoginBlockedUsers()
    func startBiometricAuth()
    func trackView()
    func trackChangeLoginTypeButton()
    func didSelectChooseEnvironment()
}

final class PLRememberedLoginPinPresenter: SafetyCurtainDoorman {
    internal let dependenciesResolver: DependenciesResolver
    weak var view: PLRememberedLoginPinViewControllerProtocol?
    public var loginConfiguration:RememberedLoginConfiguration
    public var currentBiometryType: BiometryTypeEntity = .none
    private let localAuth: LocalAuthenticationPermissionsManagerProtocol
    private var allowLoginBlockedUsers = true

    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }

    private var rememberedLoginProcessGroup: PLRememberedLoginProcessGroup {
        self.dependenciesResolver.resolve(for: PLRememberedLoginProcessGroup.self)
    }

    private var openSessionProcessGroup: PLOpenSessionProcessGroup {
        return self.dependenciesResolver.resolve(for: PLOpenSessionProcessGroup.self)
    }

    private var notificationTokenRegisterProcessGroup: PLNotificationTokenRegisterProcessGroup {
        return self.dependenciesResolver.resolve(for: PLNotificationTokenRegisterProcessGroup.self)
    }
    
    private var publicFilesManager: PublicFilesManagerProtocol {
        return self.dependenciesResolver.resolve(for: PublicFilesManagerProtocol.self)
    }
    
    private var getPLCurrentEnvironmentUseCase: GetPLCurrentEnvironmentUseCase {
        self.dependenciesResolver.resolve(for: GetPLCurrentEnvironmentUseCase.self)
    }
  
    private var rememberedLoginChangeUserUseCase: PLRememberedLoginChangeUserUseCase {
        self.dependenciesResolver.resolve(for: PLRememberedLoginChangeUserUseCase.self)
    }
    
    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?
    
    private lazy var loginPullOfferLoader: PLLoginPullOfferLoader = {
        return self.dependenciesResolver.resolve(for: PLLoginPullOfferLoader.self)
    }()
    
    var coordinator: PLRememberedLoginPinCoordinator {
        return self.dependenciesResolver.resolve(for: PLRememberedLoginPinCoordinator.self)
    }

    init(dependenciesResolver: DependenciesResolver, configuration: RememberedLoginConfiguration) {
        self.dependenciesResolver = dependenciesResolver
        self.localAuth = dependenciesResolver.resolve(for: LocalAuthenticationPermissionsManagerProtocol.self)
        self.loginConfiguration = configuration
        self.currentBiometryType = self.getBiometryTypeAvailable()
    }
}

extension PLRememberedLoginPinPresenter : PLRememberedLoginPinPresenterProtocol {
    
    func didSelectChangeUser() {
        Scenario(useCase: self.rememberedLoginChangeUserUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { [weak self] _ in
                self?.coordinator.loadUnrememberedLogin()
            }.onError { [weak self] error in
                self?.handleError(error)
            }
    }
    
    func didSelectChooseEnvironment() {
        self.coordinatorDelegate.goToEnvironmentsSelector { [weak self] in
            self?.chooseEnvironment()
        }
    }
    
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
            self.view?.showDialog(.accountTemporarilyBlocked(configuration))
            return
        }
        
        let time = Date(timeIntervalSince1970: configuration.unblockRemainingTimeInSecs ?? 0)
        if let authType = configuration.challenge?.authorizationType, authType != .softwareToken {
            self.view?.showDialog(.configurationError({ [weak self] in
                self?.coordinator.loadUnrememberedLogin()
            }))
        } else if configuration.isFinal() {
            self.view?.showDialog(.invalidSCA)
        } else if configuration.isBlocked() && time > Date() {
            self.trackEvent(.userTemporarilyBlocked)
            self.allowLoginBlockedUsers = false
            self.view?.showDialog(.accountTemporarilyBlocked(configuration))
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
        self.notificationTokenRegisterProcessGroup.execute { _ in }
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
    
    func didSelectBalance() {
        
    }

    func didSelectBlik() {
        self.trackEvent(.clickBlik)
    }

    func doLogin(with accessType: AccessType) {
        self.view?.showLoading(completion: { [weak self] in
            guard let self = self else { return }
            let config = self.coordinator.loginConfiguration
            self.rememberedLoginProcessGroup.execute(input: PLRememberedLoginProcessGroupInput(configuration: config,
                                                                                          accessType: accessType)) { result in
                switch result {
                case .success(let output):
                    self.evaluateLoginResult(configuration: output.configuration, error: nil)
                case .failure(let outputError):
                    self.evaluateLoginResult(configuration: outputError.configuration, error: outputError.error)
                }
            }
        })
    }
    
    func viewDidLoad() {
        self.trackScreen()
        self.loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    func viewWillAppear() {
        self.getCurrentEnvironments()
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
        openSessionProcessGroup.execute { [weak self] result in
            switch result {
            case .success(let output):
                self?.identifyUser(output.userId)
                self?.coordinator.goToGlobalPositionScene(output.globalPositionOption)
            case .failure(_):
                self?.coordinator.goToGlobalPositionScene(.classic)
            }
        }
    }
    
    func getBiometryTypeAvailable() -> BiometryTypeEntity {
        guard loginConfiguration.isBiometricsAvailable else { return .none }
        return self.localAuth.biometryTypeAvailable
    }
    
    func biometryFails(error: Error? = nil) {
        safetyCurtainSafeguardEventDidFinish()
        
        self.trackEvent(.apiError, parameters: [PLLoginTrackConstants.errorCode : "401",
                                                PLLoginTrackConstants.errorDescription : localized("pl_login_alert_loginError")])
        guard let laError = error as? LAError else {
            self.view?.showDialog(.unauthorized)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            switch laError.code {
            case .userFallback:
                self?.view?.tryPinAuth(withError: false)
            case .authenticationFailed, .biometryLockout, .passcodeNotSet:
                self?.view?.tryPinAuth(withError: true)
            case .userCancel:
                break
            default:
                self?.view?.showDialog(.unauthorized)
            }
        }
    }
    
    func biometrySuccess() {
        safetyCurtainSafeguardEventDidFinish()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.doLogin(with: .biometrics)
        }
    }
    
    func chooseEnvironment() {
        self.publicFilesManager.loadPublicFiles(withStrategy: .reload, timeout: 5)
        self.getCurrentEnvironments()
    }
    
    func getCurrentEnvironments() {
        Scenario(useCase: self.getPLCurrentEnvironmentUseCase).execute(on: self.dependenciesResolver.resolve())
        .onSuccess( { [weak self] result in
            self?.didLoadEnvironment(result.bsanEnvironment, publicFilesEnvironment: result.publicFilesEnvironment)
        })
    }
    
    func didLoadEnvironment(_ environment: PLEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity) {
        self.publicFilesEnvironment = publicFilesEnvironment
        let wsViewModel = EnvironmentViewModel(title: environment.name, url: environment.urlBase)
        let publicFilesViewModel = EnvironmentViewModel(title: publicFilesEnvironment.name, url: publicFilesEnvironment.urlBase)
        self.view?.updateEnvironmentsText([wsViewModel, publicFilesViewModel])
    }
    
    func loadData() {
        self.publicFilesManager.add(subscriptor: PLUnrememberedLoginIdPresenter.self) { [weak self] in
            self?.loginPullOfferLoader.loadPullOffers()
        }
    }
    
    @objc func didBecomeActive() {
        let biometryType = self.getBiometryTypeAvailable()
        guard currentBiometryType != biometryType else { return }
        self.currentBiometryType = biometryType
        view?.applicationDidBecomeActive()
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
                self.trackEvent(.userPermanentlyBlocked)
                self.view?.showDialog(.accountPermanentlyBlocked)
                return
            default:
                break
            }
        default:
            break
        }
        self.view?.showDialog(.unauthorized)
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
