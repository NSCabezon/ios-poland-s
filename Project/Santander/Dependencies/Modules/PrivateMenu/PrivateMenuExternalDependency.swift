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
    func resolve() -> GetOtherServicesSubMenuUseCase {
        return PLPrivateMenuOtherServicesUseCase(dependencies: self)
    }
    
    func resolve() -> GetMyProductSubMenuUseCase {
        return PLPrivateMenuMyProductsUseCase(dependencies: self)
    }
    
    func resolve() -> LocalAppConfig {
        oldResolver.resolve()
    }
    
    func resolve() -> GetPrivateMenuFooterOptionsUseCase {
        return PLPrivateMenuFooterOptionsUseCase()
    }
    
    func resolve() -> GetPrivateMenuOptionsUseCase {
        return PLPrivateMenuOptionsUseCase(dependencies: self)
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
}

extension BaseMenuViewController: PrivateMenuToggleOutsider { }
