//
//  AnalysisAreaDependenciesResolver.swift
//  Santander
//
//  Created by Carlos Monfort Gómez on 30/3/22.
//

import Foundation
import Menu
import CoreDomain
import CoreFoundationLib
import UI
import RetailLegacy

extension ModuleDependencies: AnalysisAreaExternalDependenciesResolver {
    func resolve() -> UserSessionFinancialHealthRepository {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }
    
    func resolve() -> FinancialHealthRepository {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }
    
    func offersCoordinator() -> BindableCoordinator {
        return resolveOfferCoordinator()
    }
}
