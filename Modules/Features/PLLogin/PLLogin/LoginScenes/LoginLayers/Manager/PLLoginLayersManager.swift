//
//  PLLoginLayerManager.swift
//  PLLogin

import Foundation
import Commons
import Models

/**
    The Login Manager is a multi-layer use cases coordinator. Can be used from different login scenes.
    The login is a complex process that affects different layers in the app. This manager move information and coordinate the different data layers.

    These are the layers and their responsability

    - Presenter Layer: Represents any scene presenter which needs to use the login manager
    - Session layer
    - Process Layer
    - Environment Layer
    - Public Files
 */

/// This protocol is adopted by the Login Manager and used from scene presenter.
protocol PLLoginLayersManagerDelegate: class {
    func doLogin(type: LoginType)
    func doAuthenticateInit()
    func doAuthenticate()
    func getCurrentEnvironments()
    func chooseEnvironment()
    func loadData()
    func continueWithLoginSuccess()
    func isSessionExpired() -> Bool
}

/// This protocol is adopted by the scene presenter and used from the Login Manager.
protocol PLLoginPresenterLayerProtocol: class {
    func handle(event: LoginProcessLayerEvent)
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
        self.loginProcessLayer.getPublicKey()
        //self.loginSessionLayer.setLoginState(.login)
    }

    func doAuthenticateInit() {
        self.loginProcessLayer.doAuthenticateInit()
    }

    func doAuthenticate() {
        self.loginProcessLayer.doAuthenticate()
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
        switch event {
        case .willLogin:
            self.publicFilesManager.cancelPublicFilesLoad(withStrategy: .initialLoad)
        case .loginWithIdentifierSuccess:
            break
        case .loginSuccess:
            //self.loginSessionLayer.handleSuccessLogin()
            break
        case .loginError, .noConnection:
            break
        }
        self.loginPresenterLayer.handle(event: event)
    }
}
