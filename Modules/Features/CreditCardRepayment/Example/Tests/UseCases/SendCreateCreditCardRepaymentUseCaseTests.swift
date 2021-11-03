//
//  SendCreateCreditCardRepaymentUseCaseTests.swift
//  CreditCardRepayment_Tests
//
//  Created by 186484 on 30/08/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Models
import Commons
import DomainCommon
import SANPLLibrary
import SANLegacyLibrary
@testable import CreditCardRepayment
@testable import Operative

class SendCreateCreditCardRepaymentUseCaseTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()

    override func setUp() {
        super.setUp()

        setUpDependencies()
    }

    func test_usecase_sendCreditCardRepayment_shouldReturnSuccess() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        let expectation = expectation(description: "Should return success")
        
        do {
            let input = SendCreditCardRepaymentUseCaseInput(form: setUpFormManagerMock())
            let useCase = SendCreditCardRepaymentUseCase(dependenciesResolver: dependencies)
            let response = try useCase.executeUseCase(requestValues: input)
            let output = try? response.getOkResult()
            
            XCTAssertNotNil(output)
            XCTAssertEqual(output?.summary.creditCard.displayPan, "545250P038230083")
            XCTAssertEqual(output?.summary.creditCard.pan, "545250_5713")
            XCTAssertEqual(output?.summary.creditCard.relatedAccount.number, "82109014894000000121595963")
            XCTAssertEqual(output?.summary.creditCard.relatedAccount.currencyCode, "PLN")
            XCTAssertEqual(output?.summary.creditCard.expirationDate, "2021-09-09T10:44:00+0000")
            
            XCTAssertEqual(output?.summary.account.number, "45609014894000000121594476")
            XCTAssertEqual(output?.summary.account.id, "1")
            XCTAssertEqual(output?.summary.account.currencyCode, "PLN")
            XCTAssertEqual(output?.summary.account.defaultForPayments, false)
            XCTAssertEqual(output?.summary.account.accountType, 101)
            
            XCTAssertEqual(output?.summary.amount.value, 130)
            XCTAssertEqual(output?.summary.amount.currency, "PLN")
            let expectedDate = ISO8601DateFormatter().date(from: "2021-09-15T10:44:00+0000")
            XCTAssertEqual(output?.summary.date, expectedDate)
            expectation.fulfill()
            
        } catch {
            XCTFail("SendCreateCreditCardRepaymentUseCaseTests failed")
        }
        
        waitForExpectations(timeout: Constants.timeout)
    }

    func test_usecase_withError_shouldReturnError() throws {
        let expectation = expectation(description: "Should return error")
        
        // Arrange
        setUpPLManagerFailureMock()
                
        do {
            let input = SendCreditCardRepaymentUseCaseInput(form: setUpFormManagerMock())
            let useCase = SendCreditCardRepaymentUseCase(dependenciesResolver: dependencies)
            let response = try useCase.executeUseCase(requestValues: input)
            let output = try? response.getErrorResult()
            XCTAssertNotNil(output)
            expectation.fulfill()
            
        } catch {
            XCTFail("SendCreateCreditCardRepaymentUseCaseTests failed")
        }
        
        waitForExpectations(timeout: Constants.timeout)
    }
    
}

private extension SendCreateCreditCardRepaymentUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: GetCreditCardsUseCase.self) { resolver in
            GetCreditCardsUseCase(dependenciesResolver: resolver)
        }

        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }

        dependencies.register(for: UseCaseHandler.self) { _ in
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
    
    func setUpFormManagerMock() -> CreditCardRepaymentForm {
        let currentBalanceAmount = AmountEntity(value: Decimal(2400), currency: .złoty)
        let availableAmount = AmountEntity(value: Decimal(5400), currency: .złoty)
        let relatedAccount = CCRAccountEntity(number: "82109014894000000121595963",
                                              alias: "12345",
                                              id: "1",
                                              taxAccountId: "423423",
                                              currencyCode: "PLN",
                                              defaultForPayments: false,
                                              currentBalanceAmount: currentBalanceAmount,
                                              availableAmount: availableAmount,
                                              accountType: 101,
                                              sequenceNumber: 1)
        
        
        let totalPaymentAmount = AmountEntity(value: Decimal(2400), currency: .złoty)
        let minimalPaymentAmount = AmountEntity(value: Decimal(2400), currency: .złoty)
        let card = CCRCardEntity(pan: "545250_5713",
                                 displayPan: "545250P038230083",
                                 alias: "545250P038230083",
                                 relatedAccount: relatedAccount,
                                 totalPaymentAmount: totalPaymentAmount,
                                 minimalPaymentAmount: minimalPaymentAmount,
                                 expirationDate: "2021-09-09T10:44:00+0000",
                                 accountType: 101,
                                 sequenceNumber: 1)
        
        let account = CCRAccountEntity(number: "45609014894000000121594476",
                                       alias: "12345",
                                       id: "1",
                                       taxAccountId: "423423",
                                       currencyCode: "PLN",
                                       defaultForPayments: false,
                                       currentBalanceAmount: currentBalanceAmount,
                                       availableAmount: availableAmount,
                                       accountType: 101,
                                       sequenceNumber: 1)
        guard let mockDate = ISO8601DateFormatter().date(from: "2021-09-15T10:44:00+0000") else { fatalError() }
        let amount = AmountEntity(value: Decimal(130), currency: .złoty)
        
        return CreditCardRepaymentForm(creditCard: card,
                                           account: account,
                                           repaymentType: .minimal,
                                           amount: amount,
                                           date: mockDate)
    }
}
