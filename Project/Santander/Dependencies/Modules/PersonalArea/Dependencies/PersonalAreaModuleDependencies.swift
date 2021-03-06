//
//  PersonalAreaModuleDependencies.swift
//  Santander
//
//  Created by alvola on 19/4/22.
//

import Foundation
import PersonalArea
import UI
import CoreFoundationLib
import PLQuickBalance

extension ModuleDependencies: PersonalAreaExternalDependenciesResolver {
    
    func resolve() -> GetPersonalAreaHomeConfigurationUseCase {
        return PLGetPersonalAreaHomeConfigurationUseCase()
    }
    
    func resolve() -> GetHomeUserPreferencesUseCase {
        return PLGetHomeUserPreferencesUseCase(dependencies: self)
    }
    
    func personalAreaCustomActionCoordinator() -> BindableCoordinator {
        return ToastCoordinator()
    }
    
    func resolve() -> GetUsernameUseCase {
        return PLGetUsernameUseCase(dependencies: self)
    }
    
    func resolve() -> EmmaTrackEventListProtocol {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }
    
    func personalAreaSecurityCustomActionCoordinator() -> BindableCoordinator {
        let navigationController: UINavigationController? = resolve()
        let quickBalancebCordinator: PLQuickBalanceCoordinatorProtocol = oldResolver.resolve()
        return PLPersonalAreaSecurityCustomActionCoordinator(quickBalancebCordinator: quickBalancebCordinator, navigationController: navigationController)
	}
    func resolve() -> GetPersonalAreaConfigurationPreferencesUseCase {
        return PLGetPersonalAreaConfigurationPreferencesUseCase(dependencies: self)
    }
}
