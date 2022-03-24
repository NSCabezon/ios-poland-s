//
//  ModuleDependencies.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/30/21.
//

import UI
import Loans
import CoreFoundationLib
import RetailLegacy
import CoreDomain
import Foundation
import Menu
import Transfer

struct ModuleDependencies {
    let oldResolver: DependenciesInjector & DependenciesResolver
    let drawer: BaseMenuViewController
    let coreDependencies = DefaultCoreDependencies()
    
    func resolve() -> TimeManager {
        oldResolver.resolve()
    }
    
    func resolve() -> DependenciesInjector {
        return oldResolver
    }
    
    func resolve() -> DependenciesResolver {
        return oldResolver
    }
    
    func resolve() -> TrackerManager {
        oldResolver.resolve()
    }
    
    func resolve() -> BaseMenuViewController {
        return drawer
    }
    
    func resolve() -> UINavigationController {
        drawer.currentRootViewController as?
        UINavigationController ?? UINavigationController()
    }
    
    func resolve() -> StringLoader {
        return oldResolver.resolve()
    }
    
    func resolve() -> PullOffersInterpreter {
        return oldResolver.resolve()
    }
}

extension ModuleDependencies: RetailLegacyExternalDependenciesResolver {
    func resolve() -> FeatureFlagsRepository {
        return asShared {
            DefaultFeatureFlagsRepository(features: CoreFeatureFlag.allCases)
        }
    }
}

extension ModuleDependencies: CoreDependenciesResolver {
    func resolve() -> CoreDependencies {
        return coreDependencies
    }
}
