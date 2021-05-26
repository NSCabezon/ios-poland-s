//
//  PLLoginLayerManager.swift
//  PLLogin

import Foundation

import Commons
import Models

protocol PLLoginLayersManagerDelegate: class {
    func doLogin(type: LoginType)
    func getCurrentEnvironments()
    func chooseEnvironment()
    func loadData()
    func continueWithLoginSuccess()
    func isSessionExpired() -> Bool
}

protocol PLLoginPresenterLayerProtocol: class {
    func handle(event: SessionProcessEvent)
    func didLoadEnvironment(_ environment: PLEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity)
    func willStartSession()
}

final class PLLoginLayersManager {
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

    private lazy var loginPresenterLayer: PLLoginPresenterLayerProtocol = {
        return self.dependenciesResolver.resolve(for: PLLoginPresenterLayerProtocol.self)
    }()

    private lazy var loginEnvironmentLayer: LoginEnvironmentLayer = {
        let environmentLayer = self.dependenciesResolver.resolve(for: LoginEnvironmentLayer.self)
        environmentLayer.setDelegate(self)
        return environmentLayer
    }()

    private lazy var loginProcessLayer: PLLoginProcessLayerProtocol = {
        let processLayer = self.dependenciesResolver.resolve(for: PLLoginProcessLayerProtocol.self)
        processLayer.setDelegate(self)
        return processLayer
    }()
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    deinit {
        self.publicFilesManager.remove(subscriptor: PLLoginLayersManager.self)
    }
}

extension PLLoginLayersManager: PLLoginLayersManagerDelegate {
    func loadData() {
        // TODO
    }
    
    func doLogin(type: LoginType) {
        self.loginProcessLayer.doLogin(with: type)
        //self.loginSessionLayer.setLoginState(.login)
    }
    
    func continueWithLoginSuccess() {
        // TODO
    }
    
    func isSessionExpired() -> Bool {
        return false // TODO: self.loginSessionLayer.isSessionExpired()
    }

    // MARK: Environment layer
    func chooseEnvironment() {
        self.publicFilesManager.loadPublicFiles(withStrategy: .reload, timeout: 5)
        self.loginEnvironmentLayer.getCurrentEnvironments()
    }

    func getCurrentEnvironments() {
        self.loginEnvironmentLayer.getCurrentEnvironments()
    }
}


// MARK: - Environment layer Delegate
extension PLLoginLayersManager: LoginEnvironmentLayerDelegate {
    func didLoadEnvironment(_ environment: PLEnvironmentEntity,
                            publicFilesEnvironment: PublicFilesEnvironmentEntity) {
        self.loginPresenterLayer.didLoadEnvironment(environment, publicFilesEnvironment: publicFilesEnvironment)
    }
}


// MARK: - Process Layer Delegate
extension PLLoginLayersManager: PLLoginProcessLayerEventDelegate {
    func handle(event: LoginProcessLayerEvent) {
        // TODO
    }
}
