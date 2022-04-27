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
    
    func sendMoneyHomeCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func depositsHomeCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func fundsHomeCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func insuranceSavingsHomeCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func insuranceProtectionHomeCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func securityCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }

    func helpCenterCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }

    func branchLocatorCoordinator() -> BindableCoordinator {
        ToastCoordinator("generic_alert_notAvailableOperation")
    }
}

extension BaseMenuViewController: PrivateMenuToggleOutsider { }
