//
//  PLLoginLayerManager.swift
//  PLLogin

import Foundation

import Commons
import Models

protocol PLLoginManagerProtocol: class {
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
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    deinit {
        self.publicFilesManager.remove(subscriptor: PLLoginLayerManager.self)
    }
}

extension PLLoginLayerManager: PLLoginManagerProtocol {
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
