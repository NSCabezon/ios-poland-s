//
//  TestCardTransactionFilterDependencies.swift
//  SantanderTests
//
//  Created by Gloria Cano López on 4/5/22.
//

import Foundation
import CoreTestData
import CoreFoundationLib
@testable import Cards

struct TestCardTransactionFiltersDependencies: CardTransactionFiltersDependenciesResolver {
    var external: CardTransactionFiltersExternalDependenciesResolver
    var dataBinding = DataBindingObject()
    let injector: MockDataInjector
    
    init(injector: MockDataInjector, externalDependencies: TestCardTransactionFiltersExternalDependencies) {
        self.injector = injector
        self.external = externalDependencies
    }
    
    func resolve() -> CardTransactionFiltersCoordinator {
        return DefaultCardTransactionFiltersCoordinator(dependencies: external, navigationController: UINavigationController())
    }
    
    func resolve() -> DataBinding {
        dataBinding
    }
}
