//
//  CardExternalDependenciesResolver.swift
//  Santander
//
//  Created by Gloria Cano López on 4/3/22.
//

import UI
import Cards
import CoreFoundationLib
import CoreDomain
import Foundation
import RetailLegacy

extension ModuleDependencies: CardExternalDependenciesResolver {
    func resolve() -> GlobalPositionReloader {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }

    func activeCardCoordinator() -> BindableCoordinator {
        return ToastCoordinator()
    }

    func resolve() -> CardRepository {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }

    func resolve() -> [CardTextColorEntity] {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }

    func resolve() -> GetCardDetailConfigurationUseCase {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }
    
    func resolve() -> CardTransactionAvailableFiltersUseCase {
        return PLCardTransactionAvailableFiltersUseCase()
    }
    
    func showPANCoordinator() -> BindableCoordinator {
        ToastCoordinator()
    }
}
