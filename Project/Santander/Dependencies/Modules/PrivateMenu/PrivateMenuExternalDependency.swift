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
    
    func sendMoneyCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func depositsCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func loansCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func fundsCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func insuranceSavingsCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func insuranceProtectionCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
}

extension BaseMenuViewController: PrivateMenuToggleOutsider { }
