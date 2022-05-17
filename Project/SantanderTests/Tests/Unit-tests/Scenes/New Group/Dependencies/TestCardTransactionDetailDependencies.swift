//
//  TestCardTransactionDetailDependencies.swift
//  SantanderTests
//
//  Created by Hernán Villamil on 12/5/22.
//

import Foundation
import CoreTestData
import CoreFoundationLib
@testable import Cards

struct TestCardTransactionDetailDependencies: CardTransactionDetailDependenciesResolver {
    var external: CardTransactionDetailExternalDependenciesResolver
    var dataBinding = DataBindingObject()
    let injector: MockDataInjector
    let mockCoordinator = MockCardTransactionDetailCoordinator()
    
    init(injector: MockDataInjector, externalDependencies: TestCardTransactionExternalDependencies) {
        self.injector = injector
        self.external = externalDependencies
    }
    
    func resolve() -> DataBinding {
        dataBinding
    }
    
    func cardTransactionDetailCoordinator() -> CardTransactionDetailCoordinator {
        mockCoordinator
    }
}
