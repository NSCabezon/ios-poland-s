//
//  PLLoginLayerManager.swift
//  PLLogin

import Foundation

import Commons
import Models

protocol PLLoginLayersManagerDelegate: class {
    func doLogin()
    func getCurrentEnvironments()
    func chooseEnvironment()
    func loadData()
    func continueWithLoginSuccess()
    func isSessionExpired() -> Bool
}

protocol PLLoginPresenterLayerProtocol: class {
    func handle(event: SessionProcessEvent)
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
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    deinit {
        self.publicFilesManager.remove(subscriptor: PLLoginLayersManager.self)
    }
}

extension PLLoginLayersManager: PLLoginLayersManagerDelegate {
    func chooseEnvironment() {
        self.publicFilesManager.loadPublicFiles(withStrategy: .reload, timeout: 5)
        //self.loginEnvironmentLayer.getCurrentEnvironments()
    }
    
    func getCurrentEnvironments() {
        //self.loginEnvironmentLayer.getCurrentEnvironments()
    }
    
    func loadData() {
        // TODO
    }
    
    func doLogin() {
        // TODO
    }
    
    func continueWithLoginSuccess() {
        // TODO
    }
    
    func isSessionExpired() -> Bool {
        return false // TODO: self.loginSessionLayer.isSessionExpired()
    }
}
