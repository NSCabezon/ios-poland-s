//
//  PrivateMenuExternalDependency.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 14/2/22.
//

import UI
import CoreDomain
import Foundation
import RetailLegacy
import CoreFoundationLib
import PrivateMenu
import BLIK
import Authorization

extension ModuleDependencies: PrivateMenuModuleExternalDependenciesResolver {
    func resolve() -> GetMyProductSubMenuUseCase {
        return PLPrivateMenuMyProductsUseCase(dependencies: self)
    }
    
    func resolve() -> GetPrivateMenuFooterOptionsUseCase {
        return PLPrivateMenuFooterOptionsUseCase()
    }
    
    func resolve() -> GetPrivateMenuOptionsUseCase {
        return PLPrivateMenuOptionsUseCase(dependencies: self)
    }
    
    func resolve() -> GetNameUseCase {
        return PLPrivateMenuGetNameUseCase(dependencies: self)
    }
    
    func resolve() -> PersonalManagerReactiveRepository {
        oldResolver.resolve()
    }
    
    func resolve() -> PersonalManagerNotificationReactiveRepository {
        oldResolver.resolve()
    }
    
    func resolve() -> PrivateMenuToggleOutsider {
        self.drawer
    }
    
    func resolve() -> GetOtherServicesSubMenuUseCase {
        return PLPrivateMenuOtherServicesUseCase(dependencies: self)
    }
    
    func depositsHomeCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func securityCoordinator() -> BindableCoordinator {
        SecurityCoordinator(dependencies: self)
    }

    func blikCoordinator() -> BindableCoordinator {
        oldResolver.resolve(for: BLIKHomeCoordinator.self)
    }
    
    func mobileAuthorizationCoordinator() -> BindableCoordinator {
        oldResolver.resolve(for: AuthorizationModuleCoordinator.self)
    }

    func branchLocatorCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }

    func insuranceProtectionHomeCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
}

extension BaseMenuViewController: PrivateMenuToggleOutsider { }
