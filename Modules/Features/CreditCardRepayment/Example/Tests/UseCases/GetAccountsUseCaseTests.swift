//
//  GetAccountsUseCaseTests.swift
//  CreditCardRepayment_Tests
//
//  Created by 186490 on 13/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Commons
@testable import CreditCardRepayment
import DomainCommon
import SANPLLibrary
import XCTest

class GetAccountsUseCaseTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()

    override func setUp() {
        super.setUp()

        setUpDependencies()
    }

    func test_usecase_withTwoAccounts_shouldReturnTwoAccounts() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        let suite = dependencies.resolve(for: GetAccountsUseCase.self)
        let useCaseScheduler = dependencies.resolve(for: UseCaseScheduler.self)
        let expectation = expectation(description: "Should return two accounts on success")

        // Act
        Scenario(useCase: suite)
            .execute(on: useCaseScheduler)
            .onSuccess { result in
                // Assert
                XCTAssertEqual(result.accounts.count, 2)

                let firstAccount = result.accounts[safe: 0]
                XCTAssertNotNil(firstAccount)
                XCTAssertEqual(firstAccount?.number, "45109014894000000121577326")
                XCTAssertEqual(firstAccount?.alias, "Konto Private Banking")
                XCTAssertEqual(firstAccount?.id, "142367733")
                XCTAssertEqual(firstAccount?.taxAccountId, nil)
                XCTAssertEqual(firstAccount?.currencyCode, "PLN")
                XCTAssertEqual(firstAccount?.defaultForPayments, false)
                XCTAssertEqual(firstAccount?.currentBalanceAmount.value, Decimal(109.1))
                XCTAssertEqual(firstAccount?.currentBalanceAmount.currency, "PLN")
                XCTAssertEqual(firstAccount?.availableAmount.value, Decimal(109.1))
                XCTAssertEqual(firstAccount?.availableAmount.currency, "PLN")

                expectation.fulfill()
            }

        waitForExpectations(timeout: Constants.timeout)
    }

    func test_usecase_withError_shouldReturnError() throws {
        // Arrange
        setUpPLManagerFailureMock()
        let suite = dependencies.resolve(for: GetAccountsUseCase.self)
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

private extension GetAccountsUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: GetAccountsUseCase.self) { resolver in
            GetAccountsUseCase(dependenciesResolver: resolver)
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
