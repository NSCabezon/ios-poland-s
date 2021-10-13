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
import PersonalArea

final class AppNavigationDependencies {
    private let drawer: BaseMenuViewController
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private lazy var sendMoneyCoordinator =
        SendMoneyCoordinator(dependenciesResolver: self.dependenciesEngine,
                             drawer: self.drawer)
    private lazy var personalAreaModuleCoordinator = PersonalAreaModuleCoordinator(dependenciesResolver: self.dependenciesEngine, navigationController: self.drawer.currentRootViewController as! UINavigationController)
    
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
        
        dependenciesEngine.register(for: PersonalAreaModuleCoordinator.self) { _ in
            return self.personalAreaModuleCoordinator
        }
    }
}
