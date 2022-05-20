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
    
    func resolve() -> GetPersonalAreaConfigurationPreferencesUseCase {
        return PLGetPersonalAreaConfigurationPreferencesUseCase(dependencies: self)
    }
}
