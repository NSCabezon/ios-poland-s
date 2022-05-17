//
//  TestGetCardTransactionDetailActionsUseCase.swift
//  SantanderTests
//
//  Created by Hernán Villamil on 12/5/22.
//

import CoreTestData
import XCTest
@testable import Cards
@testable import Santander

class TestGetCardTransactionDetailActionsUseCase: XCTestCase {
    private let card = MockCard()
    private let transaction = MockCardTransaction()
    private lazy var dependencies: TestCardTransactionDetailDependencies = {
        let external = TestCardTransactionExternalDependencies(injector: self.mockDataInjector)
        return TestCardTransactionDetailDependencies(injector: self.mockDataInjector,
                                               externalDependencies: external)
    }()
    private lazy var mockDataInjector: MockDataInjector = {
        let injector = MockDataInjector()
        injector.injectMockCardData()
        return injector
    }()
}

extension TestGetCardTransactionDetailActionsUseCase {
    func test_when_fetchCardTransactionDetailActions_expect_succes() throws {
        let sut: GetCardTransactionDetailActionsUseCase = PLGetCardTransactionDetailActionsUseCase(dependencies: dependencies.external)
        let item = MockCardTransactionViewItem(card: card,
                                               transaction: transaction,
                                               showAmountBackground: true)
        let response = try sut
            .fetchCardTransactionDetailActions(item: item)
            .sinkAwait()
        let splitableItem = SplitableCardTransaction(card: card, transaction: transaction)
        XCTAssertNotNil(response)
        XCTAssertTrue(response[0].type == .offCard)
        XCTAssertTrue(response[1].type == .share(ShareableCard(card: card)))
    }
}
