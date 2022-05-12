//
//  ModuleDependencies.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/30/21.
//

import UI
import CoreFoundationLib
import RetailLegacy
import CoreDomain
import Foundation
import Menu
import Onboarding
import SANLegacyLibrary
import SANPLLibrary
import PLCommons

struct ModuleDependencies {
    let oldResolver: DependenciesInjector & DependenciesResolver
    let drawer: BaseMenuViewController
    let coreDependencies = DefaultCoreDependencies()
    
    init(oldResolver: DependenciesInjector & DependenciesResolver, drawer: BaseMenuViewController) {
        self.oldResolver = oldResolver
        self.drawer = drawer
    }
    
    func resolve() -> TimeManager {
        return oldResolver.resolve()
    }
    
    func resolve() -> DependenciesInjector {
        return oldResolver
    }
    
    func resolve() -> DependenciesResolver {
        return oldResolver
    }
    
    func resolve() -> TrackerManager {
        return oldResolver.resolve()
    }
    
    func resolve() -> BaseMenuViewController {
        return drawer
    }
    
    func resolve() -> UINavigationController {
        return drawer.currentRootViewController as? UINavigationController ?? UINavigationController()
    }
    
    func resolve() -> StringLoader {
        return oldResolver.resolve()
    }
    
    func resolve() -> PullOffersInterpreter {
        return oldResolver.resolve()
    }

    func resolve() -> BSANManagersProvider {
        oldResolver.resolve()
    }
    
    func resolve() -> AppRepositoryProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> NavigationBarItemBuilder {
        NavigationBarItemBuilder(dependencies: self)
    }
    
    func resolve() -> PLWebViewCoordinatorDelegate {
        return PLWebViewCoordinatorNavigator(dependenciesResolver: oldResolver, drawer: drawer)
    }
    
    func resolve() -> PLGetSavingProductMatrixUseCase {
        return PLGetSavingProductMatrixUseCase(resolver: oldResolver)
    }
}

extension ModuleDependencies: RetailLegacyExternalDependenciesResolver {
    func resolve() -> FeatureFlagsRepository {
        return asShared {
            DefaultFeatureFlagsRepository(features: coreFeatureFlags())
        }
    }
    
    private func coreFeatureFlags() -> [FeatureFlagRepresentable] {
        let toRemove: Set<CoreFeatureFlag> = []
        let all: Set<CoreFeatureFlag> = Set(CoreFeatureFlag.allCases)
        return Array(all.subtracting(toRemove))
    }
}

extension ModuleDependencies: CoreDependenciesResolver {
    func resolve() -> CoreDependencies {
        return coreDependencies
    }
}
