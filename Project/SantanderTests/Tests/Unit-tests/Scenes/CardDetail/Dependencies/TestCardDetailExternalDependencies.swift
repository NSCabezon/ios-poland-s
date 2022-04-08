//
//  TestCardExternalDependencies.swift
//  SantanderTests
//
//  Created by Gloria Cano López on 10/3/22.
//

import UI
import Foundation
import CoreDomain
import CoreFoundationLib
import CoreTestData
import OpenCombine

@testable import Santander
@testable import Cards

struct TestCardDetailExternalDependencies: CardDetailExternalDependenciesResolver {
    let globalPositionRepository: MockGlobalPositionDataRepository
    let injector: MockDataInjector
    let dependencies: DependenciesResolver & DependenciesInjector
    init(injector: MockDataInjector, dependencies: DependenciesResolver & DependenciesInjector) {
        self.injector = injector
        self.dependencies = dependencies
        self.dependencies.register(for: AccountNumberFormatterProtocol.self) { _ in
                  return PLAccountNumberFormatter()
        }
        globalPositionRepository = MockGlobalPositionDataRepository(injector.mockDataProvider.gpData.getGlobalPositionMock)
        
    }
    func resolve() -> AppConfigRepositoryProtocol {
        MockAppConfigRepository(mockDataInjector: injector)
    }
    
    func resolve() -> CardRepository {
        MockCardRepository(mockDataInjector: injector)
    }
    
    func resolve() -> DependenciesResolver {
        return dependencies
    }
    
    func resolve() -> UINavigationController {
        fatalError()
    }
    
    func privateMenuCoordinator() -> Coordinator {
        fatalError()
    }
    
    func globalSearchCoordinator() -> Coordinator {
        fatalError()
    }
    
    func resolve() -> TimeManager {
        fatalError()
    }
    
    func resolve() -> GetCardsExpensesCalculationUseCase {
        return DefaultGetCardsExpensesCalculationUseCase()
    }
    
    func resolve() -> CardHomeActionModifier {
        fatalError()
    }
    
    func resolve() -> BaseURLProvider {
        BaseURLProvider(baseURL: "https://microsite.bancosantander.es/filesFF/")
    }
    
    func resolve() -> [CardTextColorEntity] {
        []
    }
    
    func moreOperativesCoordinator() -> BindableCoordinator {
        fatalError()
    }
    
    func resolve() -> CardDetailExternalDependenciesResolver {
        self
    }
    
    func showPANCoordinator() -> BindableCoordinator {
        return ToastCoordinator("")
    }
    
    func resolve() -> GlobalPositionDataRepository {
        return globalPositionRepository

    }
    
    func resolve() -> GlobalPositionReloader {
        fatalError()
    }
    
    func resolve() -> NavigationBarItemBuilder {
        fatalError()
    }
    
    func cardActivateCoordinator() -> BindableCoordinator {
        ToastCoordinator()
    }
    
    func resolve() -> TrackerManager {
        TrackerManagerMock()
    }
}
