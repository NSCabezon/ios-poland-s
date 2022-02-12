//
//  CreditCardRepaymentDetailsPresenterTests.swift
//  CreditCardRepayment_Tests
//
//  Created by 186490 on 26/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import CoreFoundationLib
@testable import CreditCardRepayment
import CoreFoundationLib
import Operative
import SANLegacyLibrary
import SANPLLibrary
import XCTest

class CreditCardRepaymentDetailsPresenterTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()

    override func setUp() {
        super.setUp()

        setUpDependencies()
    }

    func test_details_withFullfilledForm_shouldHaveHeaderFullfilled() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        setUpFormManagerSuccessMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.editHeaderViewModel?.title, localized("pl_creditCard_label_cardRep"))
        XCTAssertEqual(viewMock.editHeaderViewModel?.description, "MasterCard Silver")
        XCTAssertEqual(viewMock.editHeaderViewModel?.isEditVisible, true)
        XCTAssertNotNil(viewMock.editHeaderViewModel?.tapAction)
    }

    func test_details_withEmptyForm_shouldHaveHeaderHalfFilled() throws {
        // Arrange
        setUpPLManagerFailureMock()
        setUpFormManagerFailureMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.editHeaderViewModel?.title, localized("pl_creditCard_label_cardRep"))
        XCTAssertEqual(viewMock.editHeaderViewModel?.description, "")
        XCTAssertEqual(viewMock.editHeaderViewModel?.isEditVisible, false)
        XCTAssertNotNil(viewMock.editHeaderViewModel?.tapAction)
    }

    func test_details_withFullfilledForm_shouldHaveAccountInfoFullfilled() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        setUpFormManagerSuccessMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.accountInfoViewModel?.title, "Konto Jakie Chcę")
        XCTAssertEqual(viewMock.accountInfoViewModel?.description, localized("pl_creditCard_label_repSourceAccount"))
        XCTAssertEqual(viewMock.accountInfoViewModel?.isEdgesVisible, true)
        XCTAssertNotNil(viewMock.accountInfoViewModel?.tapAction)
    }

    func test_details_withEmptyForm_shouldHaveAccountInfoHalfFilled() throws {
        // Arrange
        setUpPLManagerFailureMock()
        setUpFormManagerFailureMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.accountInfoViewModel?.title, "")
        XCTAssertEqual(viewMock.accountInfoViewModel?.description, localized("pl_creditCard_label_repSourceAccount"))
        XCTAssertEqual(viewMock.accountInfoViewModel?.isEdgesVisible, true)
        XCTAssertNotNil(viewMock.accountInfoViewModel?.tapAction)
    }

    func test_details_withFullfilledForm_shouldHaveRepaymentTypeInfoFullfilled() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        setUpFormManagerSuccessMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.repaymentTypeInfoViewModel?.title, localized("pl_creditCard_text_repTypeMin") + " (150 PLN)")
        XCTAssertEqual(viewMock.repaymentTypeInfoViewModel?.description, localized("pl_creditCard_label_repType"))
        XCTAssertEqual(viewMock.repaymentTypeInfoViewModel?.isEdgesVisible, true)
        XCTAssertNotNil(viewMock.repaymentTypeInfoViewModel?.tapAction)
    }

    func test_details_withEmptyForm_shouldHaveRepaymentTypeInfoHalfFilled() throws {
        // Arrange
        setUpPLManagerFailureMock()
        setUpFormManagerFailureMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.repaymentTypeInfoViewModel?.title, localized("pl_creditCard_text_repTypeMin"))
        XCTAssertEqual(viewMock.repaymentTypeInfoViewModel?.description, localized("pl_creditCard_label_repType"))
        XCTAssertEqual(viewMock.repaymentTypeInfoViewModel?.isEdgesVisible, true)
        XCTAssertNotNil(viewMock.repaymentTypeInfoViewModel?.tapAction)
    }

    func test_details_withFullfilledForm_shouldHaveRepaymentAmountFullfilled() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        setUpFormManagerSuccessMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.repaymentAmountViewModel?.initialText, "150")
        XCTAssertEqual(viewMock.repaymentAmountViewModel?.placeholder, localized("pl_creditCard_label_repAmount"))
        XCTAssertEqual(viewMock.repaymentAmountViewModel?.currency, "PLN")
        XCTAssertEqual(viewMock.repaymentAmountViewModel?.canEdit, false)
        XCTAssertNil(viewMock.repaymentAmountViewModel?.errorMessage)
        XCTAssertNotNil(viewMock.repaymentAmountViewModel?.didChange)
    }

    func test_details_withEmptyForm_shouldHaveRepaymentAmountHalfFilled() throws {
        // Arrange
        setUpPLManagerFailureMock()
        setUpFormManagerFailureMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.repaymentAmountViewModel?.initialText, nil)
        XCTAssertEqual(viewMock.repaymentAmountViewModel?.placeholder, localized("pl_creditCard_label_repAmount"))
        XCTAssertEqual(viewMock.repaymentAmountViewModel?.currency, "")
        XCTAssertEqual(viewMock.repaymentAmountViewModel?.canEdit, false)
        XCTAssertNotNil(viewMock.repaymentAmountViewModel?.errorMessage)
        XCTAssertNotNil(viewMock.repaymentAmountViewModel?.didChange)
    }

    func test_details_withFullfilledForm_shouldHaveDateInfoFullfilled() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        setUpFormManagerSuccessMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.dateInfoViewModel?.text, localized("pl_creditCard_label_repDate"))
        XCTAssertEqual(viewMock.dateInfoViewModel?.date, ISO8601DateFormatter().date(from: "2021-07-22T10:44:00+0000"))
        XCTAssertNotNil(viewMock.dateInfoViewModel?.didEndEditing)
    }

    func test_details_withEmptyForm_shouldHaveDateInfoHalfFilled() throws {
        // Arrange
        setUpPLManagerFailureMock()
        setUpFormManagerFailureMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.dateInfoViewModel?.text, localized("pl_creditCard_label_repDate"))
        XCTAssertNotNil(viewMock.dateInfoViewModel?.date)
        XCTAssertNotNil(viewMock.dateInfoViewModel?.didEndEditing)
    }

    func test_details_withFullfilledForm_shouldHaveNextFullfilled() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        setUpFormManagerSuccessMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.nextViewModel?.isEnabled, true)
        XCTAssertNotNil(viewMock.nextViewModel?.tapAction)
    }

    func test_details_withEmptyForm_shouldHaveNextHalfFilled() throws {
        // Arrange
        setUpPLManagerFailureMock()
        setUpFormManagerFailureMock()
        let viewMock = CreditCardRepaymentDetailsViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()
        suite.viewWillAppear()

        // Assert
        XCTAssertEqual(viewMock.nextViewModel?.isEnabled, false)
        XCTAssertNotNil(viewMock.nextViewModel?.tapAction)
    }
}

private extension CreditCardRepaymentDetailsPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: SendCreditCardRepaymentUseCase.self) { resolver in
            SendCreditCardRepaymentUseCase(dependenciesResolver: resolver)
        }

        dependencies.register(for: CreditCardRepaymentDetailsPresenterProtocol.self) { resolver in
            CreditCardRepaymentDetailsPresenter(dependenciesResolver: resolver)
        }

        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
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

    func setUpFormManagerSuccessMock() {
        dependencies.register(for: CreditCardRepaymentFormManager.self) { resolver in
            let formManager = CreditCardRepaymentFormManagerFactoryMock.make(dependenciesResolver: resolver)
            formManager.fillCreditCardWithMockData(dependenciesResolver: resolver)
            formManager.fillDateWithMockData()
            return formManager
        }
    }

    func setUpFormManagerFailureMock() {
        dependencies.register(for: CreditCardRepaymentFormManager.self) { resolver in
            CreditCardRepaymentFormManagerFactoryMock.make(dependenciesResolver: resolver)
        }
    }
}

private extension CreditCardRepaymentFormManager {
    func fillCreditCardWithMockData(dependenciesResolver: DependenciesResolver) {
        let plManager = dependenciesResolver.resolve(for: PLCreditCardRepaymentManagerProtocol.self)

        guard case let .success(cards) = try? plManager.getCards(),
              let firstCard = cards.first,
              let creditCard = CCRCardEntity.mapCardFromDTO(firstCard)
        else {
            fatalError()
        }

        setCreditCard(creditCard)
    }

    func fillDateWithMockData() {
        guard let mockDate = ISO8601DateFormatter().date(from: "2021-07-22T10:44:00+0000") else {
            fatalError()
        }

        setDate(date: mockDate)
    }
}
