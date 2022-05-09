//
//  TestCardTransactionFilterExternalDependencies.swift
//  SantanderTests
//
//  Created by Gloria Cano López on 4/5/22.
//

import UI
import Foundation
import CoreDomain
import CoreFoundationLib
import CoreTestData
import OpenCombine

@testable import Santander
@testable import Cards

struct TestCardTransactionFiltersExternalDependencies: CardTransactionFiltersExternalDependenciesResolver {
    let injector: MockDataInjector
    
    init(injector: MockDataInjector) {
        self.injector = injector
    }
    
    func resolve() -> UINavigationController {
        fatalError()
    }
    
    func resolve() -> CardTransactionFiltersExternalDependenciesResolver {
        self
    }
    
    func resolve() -> NavigationBarItemBuilder {
        fatalError()
    }
    
    func cardExternalDependenciesResolver() -> CardExternalDependenciesResolver {
        fatalError()
    }
    
    func resolve() -> StringLoader {
        fatalError()
    }
    
    func resolve() -> TrackerManager {
        fatalError()
    }
}
