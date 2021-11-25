//
//  AccountChooseListPresenterTests.swift
//  CreditCardRepayment_Tests
//
//  Created by 186484 on 19/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Commons
@testable import CreditCardRepayment
import CoreFoundationLib
import SANPLLibrary
import XCTest

class AccountChooseListPresenterTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()

    override func setUp() {
        super.setUp()
        setUpDependencies()
    }

    func test_list_withTwoAccount_shouldBeFullfilled() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        let viewMock = AccountChooseListViewMock()
        var suite = dependencies.resolve(for: AccountChooseListPresenterProtocol.self)
        suite.view = viewMock
        let expectation = expectation(description: "Should return two Accounts on setup")

        // Act
        suite.viewDidLoad()

        // Assert
        viewMock.onSetupWithAccounts = { accounts in
            XCTAssertEqual(accounts.count, 2)

            let firstAccount = accounts[safe: 0]
            XCTAssertNotNil(firstAccount)
            XCTAssertEqual(firstAccount?.accountName, "Konto Private Banking")
            XCTAssertEqual(firstAccount?.accountAmount, "109,10 PLN")

            let secondAccount = accounts[safe: 1]
            XCTAssertNotNil(secondAccount)
            XCTAssertEqual(secondAccount?.accountName, "Konto Jakie Chcę")
            XCTAssertEqual(secondAccount?.accountAmount, "109 391,64 PLN")

            expectation.fulfill()
        }

        waitForExpectations(timeout: Constants.timeout)
    }

    func test_list_withError_shouldShowError() throws {
        // Arrange
        setUpPLManagerFailureMock()
        let viewMock = AccountChooseListViewMock()
        var suite = dependencies.resolve(for: AccountChooseListPresenterProtocol.self)
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

private extension AccountChooseListPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: GetAccountsUseCase.self) { resolver in
            GetAccountsUseCase(dependenciesResolver: resolver)
        }

        dependencies.register(for: CreditCardRepaymentFormManager.self) { resolver in
            CreditCardRepaymentFormManagerFactoryMock.make(dependenciesResolver: resolver)
        }

        dependencies.register(for: AccountChooseListPresenterProtocol.self) { resolver in
            AccountChooseListPresenter(dependenciesResolver: resolver)
        }

        dependencies.register(for: AccountChooseListViewProtocol.self) { _ in
            AccountChooseListViewMock()
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
