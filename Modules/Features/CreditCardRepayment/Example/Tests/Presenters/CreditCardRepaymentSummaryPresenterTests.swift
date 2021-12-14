//
//  CreditCardRepaymentSummaryPresenterTests.swift
//  CreditCardRepayment_Tests
//
//  Created by 186490 on 21/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Models
import Commons
import Operative
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
@testable import CreditCardRepayment

class CreditCardRepaymentSummaryPresenterTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()

    override func setUp() {
        super.setUp()

        setUpDependencies()
    }

    func test_summary_withFullfilledForm_shouldBeFullfilled() throws {
        // Arrange
        setUpPLManagerSuccessMock()
        setUpFormManagerSuccessMock()
        let viewMock = CreditCardRepaymentSummaryViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentSummaryPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()

        // Assert

        // Header
        XCTAssertEqual(viewMock.headerViewModel.title, localized("pl_creditCard_text_repSuccessText"))
        XCTAssertEqual(viewMock.headerViewModel.description, localized("pl_creditCard_text_repSuccessExpl"))

        // Body
        XCTAssertEqual(viewMock.bodyViewModels.count, 6)

        XCTAssertEqual(viewMock.bodyViewModels[safe: 0]?.title, localized("pl_creditCard_label_repAmount"))
        XCTAssertEqual(viewMock.bodyViewModels[safe: 0]?.subTitle.string, "12.345,00PLN")

        XCTAssertEqual(viewMock.bodyViewModels[safe: 1]?.title, localized("pl_creditCard_label_repSourceAccount"))
        XCTAssertEqual(viewMock.bodyViewModels[safe: 1]?.subTitle.string, "Konto Private Banking (109,10PLN)")

        XCTAssertEqual(viewMock.bodyViewModels[safe: 2]?.title, localized("pl_creditCard_label_repType"))
        XCTAssertEqual(viewMock.bodyViewModels[safe: 2]?.subTitle.string, "Spłata karty")

        XCTAssertEqual(viewMock.bodyViewModels[safe: 3]?.title, localized("pl_creditCard_label_cardRep"))
        XCTAssertEqual(viewMock.bodyViewModels[safe: 3]?.subTitle.string, "MasterCard Silver")

        XCTAssertEqual(viewMock.bodyViewModels[safe: 4]?.title, localized("pl_creditCard_label_repSourceAccountNumb"))
        XCTAssertEqual(viewMock.bodyViewModels[safe: 4]?.subTitle.string, "45 1090 1489 4000 0001 2157 7326")

        XCTAssertEqual(viewMock.bodyViewModels[safe: 5]?.title, localized("pl_creditCard_label_repDate"))
        XCTAssertEqual(viewMock.bodyViewModels[safe: 5]?.subTitle.string, "22 Jul 2021")

        // Footer
        XCTAssertEqual(viewMock.footerViewModels.count, 3)
        XCTAssertEqual(viewMock.footerTitle, localized("footerSummary_label_andNow"))

        XCTAssertEqual(viewMock.footerViewModels[safe: 0]?.title, localized("generic_button_anotherPayment"))
        XCTAssertEqual(viewMock.footerViewModels[safe: 1]?.title, localized("generic_button_globalPosition"))
        XCTAssertEqual(viewMock.footerViewModels[safe: 2]?.title, localized("generic_button_improve"))

        if case let .defaultCollapsable(visibleSections) = viewMock.collapsableSections {
            XCTAssertEqual(visibleSections, 4)
        } else {
            XCTFail()
        }

        XCTAssertTrue(viewMock.didBuildCall)
    }

    func test_summary_withEmptyForm_shouldBeHalfFilled() throws {
        // Arrange
        setUpPLManagerFailureMock()
        setUpFormManagerFailureMock()
        let viewMock = CreditCardRepaymentSummaryViewMock(dependenciesResolver: dependencies)
        let suite = dependencies.resolve(for: CreditCardRepaymentSummaryPresenterProtocol.self)
        suite.view = viewMock

        // Act
        suite.viewDidLoad()

        // Header
        XCTAssertEqual(viewMock.headerViewModel.title, localized("pl_creditCard_text_repSuccessText"))
        XCTAssertEqual(viewMock.headerViewModel.description, localized("pl_creditCard_text_repSuccessExpl"))

        // Body
        XCTAssertTrue(viewMock.bodyViewModels.isEmpty)

        // Footer
        XCTAssertEqual(viewMock.footerViewModels.count, 3)
        XCTAssertEqual(viewMock.footerTitle, localized("footerSummary_label_andNow"))

        XCTAssertEqual(viewMock.footerViewModels[safe: 0]?.title, localized("generic_button_anotherPayment"))
        XCTAssertEqual(viewMock.footerViewModels[safe: 1]?.title, localized("generic_button_globalPosition"))
        XCTAssertEqual(viewMock.footerViewModels[safe: 2]?.title, localized("generic_button_improve"))

        if case let .defaultCollapsable(visibleSections) = viewMock.collapsableSections {
            XCTAssertEqual(visibleSections, 4)
        } else {
            XCTFail()
        }

        XCTAssertTrue(viewMock.didBuildCall)
    }
}

private extension CreditCardRepaymentSummaryPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: SendCreditCardRepaymentUseCase.self) { resolver in
            SendCreditCardRepaymentUseCase(dependenciesResolver: resolver)
        }

        dependencies.register(for: CreditCardRepaymentSummaryPresenterProtocol.self) { resolver in
            CreditCardRepaymentSummaryPresenter(dependenciesResolver: resolver)
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
            formManager.fillSummaryWithMockData(dependenciesResolver: resolver)
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
    func fillSummaryWithMockData(dependenciesResolver: DependenciesResolver) {
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

        guard let mockDate = ISO8601DateFormatter().date(from: "2021-07-22T10:44:00+0000") else {
            fatalError()
        }
        
        guard let account = CCRAccountEntity.mapAccountFromDTO(firstAccount) else {
            fatalError()
        }

        let summary = CreditCardRepaymentSummary(
            creditCard: creditCard,
            account: account,
            amount: AmountEntity(AmountDTO(value: 12345, currency: currency)),
            date: mockDate,
            transferType: "Spłata karty")

        setSummary(summary)
    }
}
