//
//  CreditCardRepaymentConfirmationPresenterTests.swift
//  CreditCardRepayment_Tests
//

import XCTest
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
@testable import CreditCardRepayment
@testable import Operative

class CreditCardRepaymentConfirmationPresenterTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()

    override func setUp() {
        super.setUp()

        setUpDependencies()
    }

    func test_confirmation_withFullfilledForm_shouldBeFullfilled() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        setUpFormManagerSuccessMock()
        let viewMock = CreditCardRepaymentConfirmationViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentConfirmationPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()

        // Assert
        XCTAssertEqual(viewMock.items[safe: 0]?.title.text, "pl_creditCard_label_repAmount")
        XCTAssertTrue(((viewMock.items[safe: 0]?.value.string.contains("PLN")) != nil))
                
        XCTAssertEqual(viewMock.items[safe: 1]?.title.text, "pl_creditCard_label_repSourceAccount")
        XCTAssertTrue(((viewMock.items[safe: 1]?.value.string.contains("Konto Private Banking")) != nil))
        XCTAssertTrue(((viewMock.items[safe: 1]?.value.string.contains("PLN")) != nil))

        XCTAssertEqual(viewMock.items[safe: 2]?.title.text, "pl_creditCard_label_repSourceAccountNumb")
        XCTAssertEqual(viewMock.items[safe: 2]?.value.string, "45 1090 1489 4000 0001 2157 7326")

        XCTAssertEqual(viewMock.items[safe: 3]?.title.text, "pl_creditCard_label_cardRep")
        XCTAssertEqual(viewMock.items[safe: 3]?.value.string, "MasterCard Silver")

        XCTAssertEqual(viewMock.items[safe: 4]?.title.text, "pl_creditCard_title_repType")
        XCTAssertTrue(((viewMock.items[safe: 4]?.value.string.contains("pl_creditCard_text_repTypeMin")) != nil))
        XCTAssertTrue(((viewMock.items[safe: 4]?.value.string.contains("PLN")) != nil))
        
        XCTAssertEqual(viewMock.items[safe: 5]?.title.text, "pl_creditCard_label_repDate")
        XCTAssertTrue(!(viewMock.items[safe: 5]?.value.string.isEmpty ?? true))
    }

    func test_confirmation_withSendRepaymentSuccess_shouldSetSummary() throws {
        // Arrange
        var onSetSummary: (CreditCardRepaymentSummary) -> Void = { _ in }
        setUpPLManagerSuccessMock()
        setUpFormManagerSuccessMock(onSetSummary: { summary in
            onSetSummary(summary)
        })
        let viewMock = CreditCardRepaymentConfirmationViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentConfirmationPresenterProtocol.self)
        let formManager = dependencies.resolve(for: CreditCardRepaymentFormManager.self)
        suite.view = viewMock
        let expectation = expectation(description: "Should set summary in formManager")
        
        // Act 1
        suite.viewDidLoad()
        
        // Assert 1
        XCTAssertNil(formManager.summary)
        
        onSetSummary = { summary in
            // Assert 2
            XCTAssertNotNil(summary)
            expectation.fulfill()
        }
        
        // Act 2
        suite.didSelectContinue()
        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_confirmation_withSendRepaymentFailure_shouldShowError() throws {
        // Arrange
        setUpPLManagerFailureMock()
        setUpFormManagerFailureMock()
        let viewMock = CreditCardRepaymentConfirmationViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentConfirmationPresenterProtocol.self)
        let formManager = dependencies.resolve(for: CreditCardRepaymentFormManager.self)
        suite.view = viewMock
        let expectation = expectation(description: "Should show Error Dialog")

        // Act 1
        suite.viewDidLoad()
        
        // Assert 1
        XCTAssertNil(formManager.summary)
        
        viewMock.onShowErrorDialog = {
            // Assert 2
            XCTAssertNil(formManager.summary)
            expectation.fulfill()
        }
        
        // Act 2
        suite.didSelectContinue()
        waitForExpectations(timeout: Constants.timeout)
    }
}

private extension CreditCardRepaymentConfirmationPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: SendCreditCardRepaymentUseCase.self) { resolver in
            SendCreditCardRepaymentUseCase(dependenciesResolver: resolver)
        }

        dependencies.register(for: CreditCardRepaymentConfirmationPresenterProtocol.self) { resolver in
            CreditCardRepaymentConfirmationPresenter(dependenciesResolver: resolver)
        }

        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }

        dependencies.register(for: UseCaseScheduler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
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

    func setUpFormManagerSuccessMock(onSetSummary: @escaping (CreditCardRepaymentSummary) -> Void = { _ in } ) {
        dependencies.register(for: CreditCardRepaymentFormManager.self) { resolver in
            let formManager = CreditCardRepaymentFormManagerFactoryMock.make(dependenciesResolver: resolver)
            formManager.fillConfirmationWithMockData(dependenciesResolver: resolver)
            formManager.onSetSummary = onSetSummary
            return formManager
        }
    }

    func setUpFormManagerFailureMock() {
        dependencies.register(for: CreditCardRepaymentFormManager.self) { resolver in
            let formManager = CreditCardRepaymentFormManagerFactoryMock.make(dependenciesResolver: resolver)
            formManager.fillConfirmationWithHalfMockData(dependenciesResolver: resolver)
            return formManager
        }
    }
}

private extension CreditCardRepaymentFormManager {
    func fillConfirmationWithMockData(dependenciesResolver: DependenciesResolver) {
        let plManager = dependenciesResolver.resolve(for: PLCreditCardRepaymentManagerProtocol.self)

        guard case let .success(cards) = try? plManager.getCards(),
              let firstCard = cards.first,
              let creditCard = CCRCardEntity.mapCardFromDTO(firstCard)
        else {
            fatalError()
        }

        guard case let .success(accounts) = try? plManager.getAccountsForDebit(),
              let firstAccount = accounts.first
        else {
            fatalError()
        }

        guard let mockDate = ISO8601DateFormatter().date(from: "2021-09-02T10:44:00+0000") else {
            fatalError()
        }
        
        guard let account = CCRAccountEntity.mapAccountFromDTO(firstAccount) else {
            fatalError()
        }
        
        let amount = AmountEntity(AmountDTO(value: 150.0, currency: currency))
        setRepaymentType(.minimal, withAmount: amount)
        setCreditCard(creditCard)
        setDate(date: mockDate)
        setAccount(account)
        
    }
    
    func fillConfirmationWithHalfMockData(dependenciesResolver: DependenciesResolver) {
        guard let mockDate = ISO8601DateFormatter().date(from: "2021-09-02T10:44:00+0000") else { fatalError() }
        
        let amount = AmountEntity(AmountDTO(value: 150.0, currency: currency))
        setRepaymentType(.minimal, withAmount: amount)
        setDate(date: mockDate)
    }
}
