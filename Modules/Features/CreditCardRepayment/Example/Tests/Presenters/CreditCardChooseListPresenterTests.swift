//
//  CreditCardChooseListPresenterTests.swift
//  CreditCardRepayment_Example
//
//  Created by 186490 on 15/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import CoreFoundationLib
@testable import CreditCardRepayment
import SANPLLibrary
import XCTest

class CreditCardChooseListPresenterTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()

    override func setUp() {
        super.setUp()

        setUpDependencies()
    }

    func test_list_withTwoCreditCards_shouldBeFullfilled() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        let viewMock = CreditCardChooseListViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardChooseListPresenterProtocol.self)
        suite.view = viewMock
        let expectation = expectation(description: "Should return two credit cards on setup")
        
        // Act
        suite.viewDidLoad()
        
        // Assert
        viewMock.onSetupWithCreditCards = { creditCards in
            XCTAssertEqual(creditCards.count, 2)

            let firstCreditCard = creditCards[safe: 0]
            XCTAssertNotNil(firstCreditCard)
            XCTAssertEqual(firstCreditCard?.creditCardName, "MasterCard Silver")
            XCTAssertEqual(firstCreditCard?.lastCreditCardDigits, "*5713")

            let secondCreditCard = creditCards[safe: 1]
            XCTAssertNotNil(secondCreditCard)
            XCTAssertEqual(secondCreditCard?.creditCardName, "Karta kredytowa 123")
            XCTAssertEqual(secondCreditCard?.lastCreditCardDigits, "*8846")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_list_withTwoCreditCards_shouldShowError() throws {
        // Arrange
        setUpPLManagerFailureMock()
        let viewMock = CreditCardChooseListViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardChooseListPresenterProtocol.self)
        suite.view = viewMock
        let expectation = expectation(description: "Should return error on setup")
        
        // Act
        suite.viewDidLoad()
        
        // Assert
        viewMock.onShowError = {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Constants.timeout)
    }
}

private extension CreditCardChooseListPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: GetCreditCardsUseCase.self) { resolver in
            GetCreditCardsUseCase(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: CreditCardRepaymentFormManager.self) { resolver in
            CreditCardRepaymentFormManagerFactoryMock.make(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: CreditCardChooseListPresenterProtocol.self) { resolver in
            CreditCardChooseListPresenter(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: CreditCardChooseListViewProtocol.self) { resolver in
            CreditCardChooseListViewMock(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
                
        dependencies.register(for: UseCaseScheduler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
        
        dependencies.register(for: CreateCreditCardRepaymentFormUseCaseProtocol.self) { dependenciesResolver in
            CreateCreditCardRepaymentFormUseCase(dependenciesResolver: dependenciesResolver)
        }
    }
    
    func setUpPLManagerSuccessMock() {
        dependencies.register(for: PLCreditCardRepaymentManagerProtocol.self) { _ in
            PLCreditCardRepaymentManagerMock()
        }
    }

    func setUpPLManagerFailureMock() {
        dependencies.register(for: PLCreditCardRepaymentManagerProtocol.self) { _ in
            let mock = PLCreditCardRepaymentManagerMock()
            mock.forceError = true
            return mock
        }
    }
}
