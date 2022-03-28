//
//  ModuleDependencies.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/16/21.
//
import UI
import Loans
import Commons
import CoreDomain
import Foundation
import RetailLegacy
import CoreFoundationLib
import Transfer

struct ModuleDependencies {
    let legacyDependenciesResolver: DependenciesInjector & DependenciesResolver
    let drawer: BaseMenuViewController
    
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
        legacyDependenciesResolver.register(for: OneTransferHomeExternalDependenciesResolver.self) { _ in
            self
        }
    }
}
