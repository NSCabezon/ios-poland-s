//
//  PLInternalTransferConfirmationUseCaseTest.swift
//  SantanderTests
//
//  Created by Cristobal Ramos Laina on 16/3/22.
//

import XCTest
import CoreTestData
import CoreFoundationLib
import UI
import SANLegacyLibrary
import OpenCombine
import UnitTestCommons
import CoreDomain
@testable import Santander
@testable import TransferOperatives

class PLInternalTransferConfirmationUseCaseTest: XCTestCase {
    var dependencies: PLInternalTransferOperativeExternalDependenciesResolver!
    private var mockDataInjector = MockDataInjector()
    private var sut: PLInternalTransferConfirmationUseCase!
    private var globalPositionMock: GlobalPositionRepresentable!
    private var polandAccount: AccountRepresentable!
    private var notPolandAccount: AccountRepresentable!
    override func setUp() {
        self.registrationManyAccounts()
        globalPositionMock = self.getGlobalPositionMock()
        dependencies = PLInternalTransferOperativeExternalDependenciesResolverTest()
        self.sut = PLInternalTransferConfirmationUseCase(dependencies: dependencies)
        let accounts = globalPositionMock.accounts.map { entity in
            entity.representable
        }
        polandAccount = accounts[0]
        notPolandAccount = accounts[2]
    }
    
    func test_Given_PolandAccounts_Then_58_ONEAPP_OWN_TRANSACTION() {
        let value = self.sut.internalTransferMatrix(InternalTransferConfirmationUseCaseInput(originAccount: polandAccount, destinationAccount: polandAccount, name: nil, alias: nil, amount: AmountRepresented(value: 5, currencyRepresentable: CurrencyRepresented(currencyName: nil, currencyCode: "")), concept: nil, type: .national, time: nil))
        XCTAssertTrue(value == "ONEAPP_OWN_TRANSACTION")
    }
    
    func test_Given_NotPolandAccounts_Then_61_ONEAPP_OWN_CURRENCY_TRANSACTION() {
        let value = self.sut.internalTransferMatrix(InternalTransferConfirmationUseCaseInput(originAccount: notPolandAccount, destinationAccount: notPolandAccount, name: nil, alias: nil, amount: AmountRepresented(value: 5, currencyRepresentable: CurrencyRepresented(currencyName: nil, currencyCode: "")), concept: nil, type: .national, time: nil))
        XCTAssertTrue(value == "ONEAPP_OWN_CURRENCY_TRANSACTION")
    }
    
    func test_Given_NotPolandOriginAccount_Then_61_ONEAPP_OWN_CURRENCY_TRANSACTION() {
        let value = self.sut.internalTransferMatrix(InternalTransferConfirmationUseCaseInput(originAccount: notPolandAccount, destinationAccount: polandAccount, name: nil, alias: nil, amount: AmountRepresented(value: 5, currencyRepresentable: CurrencyRepresented(currencyName: nil, currencyCode: "")), concept: nil, type: .national, time: nil))
        XCTAssertTrue(value == "ONEAPP_OWN_CURRENCY_TRANSACTION")
    }
    
    func test_Given_NotPolandDestinationAccount_Then_61_ONEAPP_OWN_CURRENCY_TRANSACTION() {
        let value = self.sut.internalTransferMatrix(InternalTransferConfirmationUseCaseInput(originAccount: polandAccount, destinationAccount: notPolandAccount, name: nil, alias: nil, amount: AmountRepresented(value: 5, currencyRepresentable: CurrencyRepresented(currencyName: nil, currencyCode: "")), concept: nil, type: .national, time: nil))
        XCTAssertTrue(value == "ONEAPP_OWN_CURRENCY_TRANSACTION")
    }
}

private extension PLInternalTransferConfirmationUseCaseTest {
    func registrationManyAccounts() {
        self.mockDataInjector.register(
            for: \.gpData.getGlobalPositionMock,
            filename: "PLobtenerPosGlobal"
        )
    }

    func getGlobalPositionMock() -> GlobalPositionMock {
        return GlobalPositionMock(
            self.mockDataInjector.mockDataProvider.gpData.getGlobalPositionMock,
            cardsData: [:],
            temporallyOffCards: [:],
            inactiveCards: [:],
            cardBalances: [:]
            )
    }
}
