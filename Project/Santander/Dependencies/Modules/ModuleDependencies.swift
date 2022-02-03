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

struct ModuleDependencies {
    
    let oldResolver: DependenciesInjector & DependenciesResolver
    let drawer: BaseMenuViewController
    let coreDependencies = DefaultCoreDependencies()
    
    func resolve() -> TimeManager {
        oldResolver.resolve()
    }

    func resolve() -> DependenciesResolver {
        return oldResolver
    }
    
    func resolve() -> AppConfigRepositoryProtocol {
        oldResolver.resolve()
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
}

extension ModuleDependencies: RetailLegacyExternalDependenciesResolver {}
extension ModuleDependencies: CoreDependenciesResolver {
    
    func resolve() -> CoreDependencies {
        return coreDependencies
    }
}
