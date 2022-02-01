//
//  ModuleDependencies.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/30/21.
//

import UI
import Loans
import Commons
import CoreDomain
import Foundation
import RetailLegacy
import CoreFoundationLib
import Transfer

struct ModuleDependencies: RetailLegacyExternalDependenciesResolver {
    
    let legacyDependenciesResolver: DependenciesInjector & DependenciesResolver
    let drawer: BaseMenuViewController
    let coreDependencies = DefaultCoreDependencies()

    func resolve() -> TimeManager {
        legacyDependenciesResolver.resolve()
    }

    func resolve() -> DependenciesResolver {
        return legacyDependenciesResolver
    }
    
    func resolve() -> AppConfigRepositoryProtocol {
        legacyDependenciesResolver.resolve()
    }
    
    func resolve() -> TrackerManager {
        legacyDependenciesResolver.resolve()
    }
    
    func resolve() -> GlobalPositionRepository {
        return DefaultGlobalPositionRepository.current
    }
    
    func resolve() -> BaseMenuViewController {
        return drawer
    }
    
    func resolve() -> UINavigationController {
        drawer.currentRootViewController as?
        UINavigationController ?? UINavigationController()
    }
}

extension ModuleDependencies {
    func registerRetailLegacyDependencies() {
        legacyDependenciesResolver.register(for: RetailLegacyExternalDependenciesResolver.self) { _ in
            self
        }
        legacyDependenciesResolver.register(for: GlobalPositionRepository.self) { _ in
            return DefaultGlobalPositionRepository.current
        }
        legacyDependenciesResolver.register(for: OneTransferHomeExternalDependenciesResolver.self) { _ in
            self
        }
    }
}

extension ModuleDependencies: LegacyCoreDependenciesResolver, CoreDependenciesResolver {
    
    func resolve() -> CoreDependencies {
        return coreDependencies
    }
}
