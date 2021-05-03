//
//  AppNavigationDependencies.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

import LoginCommon
//import PLLogin // TODO: uncomment when module is created
import Commons
import RetailLegacy

final class AppNavigationDependencies {
    private let drawer: BaseMenuViewController
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    init(drawer: BaseMenuViewController, dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.drawer = drawer
        self.dependenciesEngine = dependenciesEngine
    }
    
    func registerDependencies() {
//        dependenciesEngine.register(for: LoginModuleCoordinatorProtocol.self) { dependenciesResolver in
//            return LoginPLModuleCoordinator(dependenciesResolver: dependenciesResolver, navigationController: drawer.currentRootViewController as? UINavigationController)
//        }
    }
}
