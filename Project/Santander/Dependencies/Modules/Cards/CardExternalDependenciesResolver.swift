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

    func resolve() -> CardRepository {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }

    func resolve() -> [CardTextColorEntity] {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }
}

// MARK: - Use cases
extension ModuleDependencies {
    func resolve() -> GetCardDetailConfigurationUseCase {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }
    
    func resolve() -> CardTransactionAvailableFiltersUseCase {
        return PLCardTransactionAvailableFiltersUseCase()
    }
    
    func resolve() -> FirstFeeInfoEasyPayReactiveUseCase {
        return DefaultFirstFeeInfoEasyPayReactiveUseCase(repository: resolve())
    }
    
    func resolve() -> GetCardTransactionDetailActionsUseCase {
        return PLGetCardTransactionDetailActionsUseCase(dependencies: self)
    }
    
    func resolve() -> CardTransactionDetailUseCase {
        return PLCardTransactionDetailUseCase(dependencies: self)
    }
    
    func resolve() -> GetCardTransactionDetailViewConfigurationUseCase {
        return PLGetCardTransactionDetailViewConfigurationUseCase()
    }
}

// MARK: - Coordinators
extension ModuleDependencies {
    func activeCardCoordinator() -> BindableCoordinator {
        return ToastCoordinator()
    }
    
    func showPANCoordinator() -> BindableCoordinator {
        ToastCoordinator()
    }
    
    func cardCustomeCoordinator() -> BindableCoordinator {
        return ToastCoordinator("Selected Action")
    }
    
    func cardPdfDetailCoordinator() -> BindableCoordinator {
        let oldResolver: DependenciesResolver = resolve()
        return PLCardPdfDetailCoordinator(dependenciesResolver: oldResolver)
    }
}
