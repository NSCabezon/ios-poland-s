//
//  AppNavigationDependencies.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

import LoginCommon
import PLLogin
import Commons
import PLCommons
import RetailLegacy
import PersonalArea
import BLIK
import PLHelpCenter
import CreditCardRepayment

final class AppNavigationDependencies {
    private let drawer: BaseMenuViewController
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private lazy var sendMoneyCoordinator =
        SendMoneyCoordinator(dependenciesResolver: self.dependenciesEngine,
                             drawer: self.drawer)
    private lazy var personalAreaModuleCoordinator = PersonalAreaModuleCoordinator(dependenciesResolver: self.dependenciesEngine, navigationController: self.drawer.currentRootViewController as? UINavigationController)
    private let appSideMenuNavigationDependencies: AppSideMenuNavigationDependencies
    
    init(drawer: BaseMenuViewController, dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.drawer = drawer
        self.dependenciesEngine = dependenciesEngine
        self.appSideMenuNavigationDependencies = AppSideMenuNavigationDependencies(drawer: drawer, dependenciesEngine: dependenciesEngine)
    }

    func registerDependencies() {
        dependenciesEngine.register(for: LoginModuleCoordinatorProtocol.self) { resolver in
            return PLLoginModuleCoordinator(dependenciesResolver: resolver, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        
        dependenciesEngine.register(for: SendMoneyCoordinatorProtocol.self) { _ in
            return self.sendMoneyCoordinator
        }
        
        dependenciesEngine.register(for: PLLoginWebViewCoordinatorDelegate.self) { _ in
            return PLWebViewCoordinatorNavigator(dependenciesResolver: self.dependenciesEngine, drawer: self.drawer)
        }
        dependenciesEngine.register(for: PLWebViewCoordinatorDelegate.self) { _ in
            return PLWebViewCoordinatorNavigator(dependenciesResolver: self.dependenciesEngine, drawer: self.drawer)
        }
        
        dependenciesEngine.register(for: PersonalAreaModuleCoordinator.self) { _ in
            return self.personalAreaModuleCoordinator
        }
        dependenciesEngine.register(for: BLIKHomeCoordinator.self) { resolver in
            return BLIKHomeCoordinator(dependenciesResolver: resolver, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: PLHelpCenterModuleCoordinator.self) { resolver in
            return PLHelpCenterModuleCoordinator(dependenciesResolver: resolver, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: CreditCardRepaymentModuleCoordinator.self) { resolver in
            return CreditCardRepaymentModuleCoordinator(dependenciesResolver: resolver, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: OneAppInitCoordinatorProtocol.self) { [unowned self] resolver in // Temporary [DEBUG MENU] on GlobalPosition
            return OneAppInitCoordinator(dependenciesEngine: self.dependenciesEngine, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: DebugMenuLauncherDelegate.self) { [unowned self] resolver in // Temporary [DEBUG WELCOME] on Login
            return OneAppInitWelcomeCoordinator(dependenciesEngine: self.dependenciesEngine, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        
        appSideMenuNavigationDependencies.registerDependencies()
        DeeplinkDependencies(drawer: drawer, dependenciesEngine: dependenciesEngine).registerDependencies()
    }
}

extension OneAppInitWelcomeCoordinator: DebugMenuLauncherDelegate {} // Temporary [DEBUG WELCOME] on Login
