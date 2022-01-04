//
//  CreateCreditCardRepaymentFormUseCase.swift
//  CreditCardRepayment_Tests
//
//  Created by 186493 on 30/08/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Commons
@testable import CreditCardRepayment
import CoreFoundationLib
import SANPLLibrary
import XCTest
import SANLegacyLibrary

class CreateCreditCardRepaymentFormUseCaseTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()

    override func setUp() {
        super.setUp()

        setUpDependencies()
    }

    func test_useCase_withTwoCreditCards_shouldReturnThreeStepsAndFormWithoutSelectedCard() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        let suite = dependencies.resolve(for: CreateCreditCardRepaymentFormUseCase.self)
        let requestedValue = CreateCreditCardRepaymentFormUseCaseOkInput(creditCardEntity: nil)
        let expectation = expectation(description: "Should return 3 steps and form without selected card")
        
        // Act
        Scenario(useCase: suite, input: requestedValue)
            .execute(on: dependencies.resolve())
            .onSuccess { output in
                // Assert
                XCTAssertEqual(output.steps, [.chooseCard, .form, .confirm])
                XCTAssertEqual(output.accountSelectionPossible, true)
                XCTAssertEqual(output.currency.currencyType, .złoty)
                XCTAssertNil(output.form.creditCard)
                XCTAssertNotNil(output.form.account)
                XCTAssertNotNil(output.form.repaymentType)
                XCTAssertNil(output.form.amount)
                XCTAssertNotNil(output.form.date)
                
                expectation.fulfill()
            }

        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_withOneCreditCard_shouldReturnTwoStepsAndFormWithSelectedCard() throws {
        // Arrange
        setUpPLManagerSuccessMock(maxCardLimit: 1)
        let suite = dependencies.resolve(for: CreateCreditCardRepaymentFormUseCase.self)
        let requestedValue = CreateCreditCardRepaymentFormUseCaseOkInput(creditCardEntity: nil)
        let expectation = expectation(description: "Should return 2 steps and form with selected card")
        
        // Act
        Scenario(useCase: suite, input: requestedValue)
            .execute(on: dependencies.resolve())
            .onSuccess { output in
                // Assert
                XCTAssertEqual(output.steps, [.form, .confirm])
                XCTAssertEqual(output.accountSelectionPossible, true)
                XCTAssertEqual(output.currency.currencyType, .złoty)
                XCTAssertNotNil(output.form.creditCard)
                XCTAssertNotNil(output.form.account)
                XCTAssertNotNil(output.form.repaymentType)
                XCTAssertNotNil(output.form.amount)
                XCTAssertNotNil(output.form.date)
                
                expectation.fulfill()
            }

        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_withTwoCreditCardsButOneIsInitailySelected_shouldReturnTwoStepsAndFormWithSelectedCard() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        let suite = dependencies.resolve(for: CreateCreditCardRepaymentFormUseCase.self)
        var cardDTO = SANLegacyLibrary.CardDTO()
        cardDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: "545250P038230083")
        let requestedValue = CreateCreditCardRepaymentFormUseCaseOkInput(
            creditCardEntity: CardEntity(cardDTO)
        )
        let expectation = expectation(description: "Should return 2 steps and form with selected card")
        
        // Act
        Scenario(useCase: suite, input: requestedValue)
            .execute(on: dependencies.resolve())
            .onSuccess { output in
                // Assert
                XCTAssertEqual(output.steps, [.form, .confirm])
                XCTAssertEqual(output.accountSelectionPossible, true)
                XCTAssertEqual(output.currency.currencyType, .złoty)
                XCTAssertNotNil(output.form.creditCard)
                XCTAssertEqual(output.form.creditCard?.relatedAccount.number, "63109014894000000121600961")
                XCTAssertEqual(output.form.creditCard?.pan, "545250P038230083")
                XCTAssertNotNil(output.form.account)
                XCTAssertNotNil(output.form.repaymentType)
                XCTAssertNotNil(output.form.amount)
                XCTAssertNotNil(output.form.date)
                
                expectation.fulfill()
            }

        waitForExpectations(timeout: Constants.timeout)
    }

    func test_useCase_withError_shouldReturnFetchingTroubleError() throws {
        // Arrange
        setUpPLManagerFailureMock()
        let suite = dependencies.resolve(for: CreateCreditCardRepaymentFormUseCase.self)
        let requestedValue = CreateCreditCardRepaymentFormUseCaseOkInput(creditCardEntity: nil)
        let expectation = expectation(description: "Should return fetchingTrouble error on error")
        
        // Act
        Scenario(useCase: suite, input: requestedValue)
            .execute(on: dependencies.resolve())
            .onError { error in
                XCTAssertEqual(error.getErrorDesc(), CreateCreditCardRepaymentFormError.fetchingTrouble.rawValue)
                expectation.fulfill()
            }

        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_withNoCards_shouldReturnNoCardsError() throws {
        // Arrange
        setUpPLManagerSuccessMock(maxCardLimit: 0)
        let suite = dependencies.resolve(for: CreateCreditCardRepaymentFormUseCase.self)
        let requestedValue = CreateCreditCardRepaymentFormUseCaseOkInput(creditCardEntity: nil)
        let expectation = expectation(description: "Should return featchingTrouble error on error")
        
        // Act
        Scenario(useCase: suite, input: requestedValue)
            .execute(on: dependencies.resolve())
            .onError { error in
                XCTAssertEqual(error.getErrorDesc(), CreateCreditCardRepaymentFormError.noCards.rawValue)
                expectation.fulfill()
            }

        waitForExpectations(timeout: Constants.timeout)
    }
}

private extension CreateCreditCardRepaymentFormUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: CreateCreditCardRepaymentFormUseCase.self) { resolver in
            CreateCreditCardRepaymentFormUseCase(dependenciesResolver: resolver)
        }

        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: UseCaseScheduler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
    }

    func setUpPLManagerSuccessMock(maxCardLimit: Int = .max) {
        dependencies.register(for: PLCreditCardRepaymentManagerProtocol.self) { _ in
            let mock = PLCreditCardRepaymentManagerMock()
            mock.maxCardLimit = maxCardLimit
            return mock
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
