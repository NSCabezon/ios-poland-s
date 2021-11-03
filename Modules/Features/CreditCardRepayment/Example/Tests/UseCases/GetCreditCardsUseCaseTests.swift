//
//  GetCreditCardsUseCaseTests.swift
//  CreditCardRepayment_Tests
//
//  Created by 186484 on 16/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Commons
@testable import CreditCardRepayment
import DomainCommon
import SANPLLibrary
import XCTest

class GetCreditCardsUseCaseTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()

    override func setUp() {
        super.setUp()

        setUpDependencies()
    }

    func test_usecase_withTwoCreditCards_shouldReturnTwoCreditCard() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        let suite = dependencies.resolve(for: GetCreditCardsUseCase.self)
        let useCaseScheduler = dependencies.resolve(for: UseCaseScheduler.self)
        let expectation = expectation(description: "Should return two Credit Cards on success")

        // Act
        Scenario(useCase: suite)
            .execute(on: useCaseScheduler)
            .onSuccess { result in
                // Assert
                XCTAssertEqual(result.cards.count, 2)
                
                let firstCard = result.cards[safe: 0]
                XCTAssertNotNil(firstCard)
                XCTAssertEqual(firstCard?.pan, "545250P038230083")
                XCTAssertEqual(firstCard?.displayPan, "545250_5713")
                XCTAssertEqual(firstCard?.alias, "MasterCard Silver")
                XCTAssertEqual(firstCard?.totalPaymentAmount.value, Decimal(300))
                XCTAssertEqual(firstCard?.totalPaymentAmount.currency, "PLN")
                XCTAssertEqual(firstCard?.minimalPaymentAmount.value, Decimal(150))
                XCTAssertEqual(firstCard?.minimalPaymentAmount.currency, "PLN")
                XCTAssertEqual(firstCard?.expirationDate, "2025-06-30")
                
                expectation.fulfill()
            }

        waitForExpectations(timeout: Constants.timeout)
    }

    func test_usecase_withError_shouldReturnError() throws {
        // Arrange
        setUpPLManagerFailureMock()
        let suite = dependencies.resolve(for: GetCreditCardsUseCase.self)
        let useCaseScheduler = dependencies.resolve(for: UseCaseScheduler.self)
        let expectation = expectation(description: "Should return error on error")

        // Act
        Scenario(useCase: suite)
            .execute(on: useCaseScheduler)
            .onError { _ in
                // Assert
                expectation.fulfill()
            }

        waitForExpectations(timeout: Constants.timeout)
    }
}

private extension GetCreditCardsUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: GetCreditCardsUseCase.self) { resolver in
            GetCreditCardsUseCase(dependenciesResolver: resolver)
        }

        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }

        dependencies.register(for: UseCaseScheduler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
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
