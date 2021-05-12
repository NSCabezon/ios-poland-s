//
//  PLLoginLayerManager.swift
//  PLLogin

import Foundation

import Commons
import Models

protocol PLLoginManagerProtocol: class {
    func doLogin(type: LoginType)
    func getCurrentEnvironments()
    func chooseEnvironment()
    func loadData()
    func continueWithLoginSuccess()
    func isSessionExpired() -> Bool
}

protocol PLLoginPresenterLayerProtocol: class {
    func handle(event: LoginProcessLayerEvent)
    func handle(event: SessionProcessEvent)
    func didLoadEnvironment(_ environment: PTEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity)
    func willStartSession()
}

final class PLLoginLayerManager {
    private let dependenciesResolver: DependenciesResolver
    
    private var publicFilesManager: PublicFilesManagerProtocol {
        return self.dependenciesResolver.resolve(for: PublicFilesManagerProtocol.self)
    }
    
    private var pushNotificationRegister: PushNotificationRegisterManagerProtocol {
        return self.dependenciesResolver.resolve(for: PushNotificationRegisterManagerProtocol.self)
    }
    
    private var pushNotificationExcecutor: PushNotificationExecutorProtocol {
        self.dependenciesResolver.resolve(for: PushNotificationExecutorProtocol.self)
    }
    
    private lazy var loginPTProcessLayer: LoginPTProcessLayerProtocol = {
        let processLayer = self.dependenciesResolver.resolve(for: LoginPTProcessLayerProtocol.self)
        processLayer.setDelegate(self)
        return processLayer
    }()
    
    private lazy var loginPTPresenterLayer: LoginPTPresenterLayerProtocol = {
        return self.dependenciesResolver.resolve(for: LoginPTPresenterLayerProtocol.self)
    }()
    
    private lazy var loginSessionLayer: LoginSessionLayer = {
        let sessionLayer = self.dependenciesResolver.resolve(for: LoginSessionLayer.self)
        sessionLayer.setDelegate(self)
        return sessionLayer
    }()
    
    private lazy var loginEnvironmentLayer: LoginEnvironmentLayer = {
        let environmentLayer = self.dependenciesResolver.resolve(for: LoginEnvironmentLayer.self)
        environmentLayer.setDelegate(self)
        return environmentLayer
    }()
    
    private lazy var loginPTPullOfferLayer: LoginPTPullOfferLayer = {
        let pullOfferLayer = self.dependenciesResolver.resolve(for: LoginPTPullOfferLayer.self)
        pullOfferLayer.setDelegate(self)
        return pullOfferLayer
    }()
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    deinit {
        self.publicFilesManager.remove(subscriptor: LoginPTLayerManager.self)
    }
}

extension PLLoginLayerManager: LoginPTManagerProtocol {
    func chooseEnvironment() {
        self.publicFilesManager.loadPublicFiles(withStrategy: .reload, timeout: 5)
        self.loginEnvironmentLayer.getCurrentEnvironments()
    }
    
    func getCurrentEnvironments() {
        self.loginEnvironmentLayer.getCurrentEnvironments()
    }
    
    func loadData() {
        if self.loginSessionLayer.getCloseReason() != .unknown {
            self.publicFilesManager.loadPublicFiles(withStrategy: .initialLoad, timeout: 0)
        }
        self.publicFilesManager.add(subscriptor: LoginPTLayerManager.self) { [weak self] in
            self?.publicFilesLoadingDidFinish()
        }
        self.pushNotificationExcecutor.executeNotificationReceived()
    }
    
    func doLogin(type: LoginType) {
        self.loginPTProcessLayer.doLogin(with: type)
    }
    
    func continueWithLoginSuccess() {
        handle(event: .loginSuccess)
    }
    
    func isSessionExpired() -> Bool {
        return self.loginSessionLayer.isSessionExpired()
    }
}

extension PLLoginLayerManager: LoginPTProcessLayerEventDelegate {
    func handle(event: LoginProcessLayerEvent) {
        switch event {
        case .willLogin:
            self.publicFilesManager.cancelPublicFilesLoad(withStrategy: .initialLoad)
        case .loginSuccess:
            self.loginSessionLayer.handleSuccessLogin()
            self.pushNotificationExcecutor.updateUserInfo()
        case .loginError, .accountTemporaryLocked, .wrongCredentials, .termsAndConditions, .noConnection, .sca, .incorrectSCA, .scaPhoneList, .noSCAPhones, .scaExpired, .permanentlyBlocked, .pinLocked:
            break
        }
        self.loginPTPresenterLayer.handle(event: event)
    }
}

extension PLLoginLayerManager: LoginSessionLayerEventDelegate {
    func handle(event: SessionProcessEvent) {
        self.loginPTPresenterLayer.handle(event: event)
    }
    
    func willOpenSession(completion: @escaping () -> Void) {
        self.loginPTPresenterLayer.willStartSession()
        self.publicFilesManager.add(subscriptor: LoginPTLayerManager.self) {
            completion()
        }
    }
}

extension PLLoginLayerManager: LoginPTPullOfferLayerDelegate {
    func publicFilesLoadingDidFinish() {
        self.loginPTPullOfferLayer.loadPullOffers()
    }
    
    func loadPullOffersSuccess() {
    }
}

extension PLLoginLayerManager: LoginEnvironmentLayerDelegate {
    func didLoadEnvironment(_ environment: PTEnvironmentEntity,
                            publicFilesEnvironment: PublicFilesEnvironmentEntity) {
        self.loginPTPresenterLayer.didLoadEnvironment(environment, publicFilesEnvironment: publicFilesEnvironment)
    }
}
