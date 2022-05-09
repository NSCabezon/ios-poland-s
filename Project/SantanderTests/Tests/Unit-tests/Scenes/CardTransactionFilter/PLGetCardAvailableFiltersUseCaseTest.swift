//
//  PTGetCardAvailableFiltersUseCaseTest.swift
//  SantanderTests
//
//  Created by Gloria Cano López on 4/5/22.
//

import CoreTestData
import XCTest
@testable import Cards
@testable import Santander

class PLGetCardAvailableFiltersUseCaseTest: XCTestCase {
    lazy var dependencies: TestCardTransactionFiltersDependencies = {
        let external = TestCardTransactionFiltersExternalDependencies(injector: self.mockDataInjector)
        return TestCardTransactionFiltersDependencies(injector: self.mockDataInjector,
                                               externalDependencies: external)
    }()
    
    lazy var mockDataInjector: MockDataInjector = {
        let injector = MockDataInjector()
        return injector
    }()
    
    func test_availableFilters_shouldReturnTrueForConcept_TypeOfMovement_andAmount() throws {
        let sut = PLCardTransactionAvailableFiltersUseCase()
        
        let filters = try sut.fetchAvailableFiltersPublisher().sinkAwait()
        XCTAssertTrue(filters.byAmount)
        XCTAssertTrue(filters.byExpenses)
        XCTAssertFalse(filters.byTypeOfMovement)
        XCTAssertTrue(filters.byConcept)
    }
}
