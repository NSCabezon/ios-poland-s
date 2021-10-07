//
//  AppNavigationDependencies.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

import LoginCommon
import PLLogin
import Commons
import RetailLegacy

final class AppNavigationDependencies {
    private let drawer: BaseMenuViewController
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private lazy var sendMoneyCoordinator =
        SendMoneyCoordinator(dependenciesResolver: self.dependenciesEngine,
                             drawer: self.drawer)
    
    init(drawer: BaseMenuViewController, dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.drawer = drawer
        self.dependenciesEngine = dependenciesEngine
    }

    func registerDependencies() {
        dependenciesEngine.register(for: LoginModuleCoordinatorProtocol.self) { resolver in
            return PLLoginModuleCoordinator(dependenciesResolver: resolver, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        
        dependenciesEngine.register(for: SendMoneyCoordinatorProtocol.self) { _ in
            return self.sendMoneyCoordinator
        }
    }
}
