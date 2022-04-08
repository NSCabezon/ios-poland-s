//
//  PLInternalTransferPreSetupUseCaseTest.swift
//  SantanderTests
//
//  Created by Cristobal Ramos Laina on 17/3/22.
//

import XCTest
import CoreTestData
import CoreFoundationLib
import UI
import SANLegacyLibrary
import OpenCombine
import UnitTestCommons
import CoreDomain
import SANPLLibrary
@testable import Santander
@testable import TransferOperatives

class PLInternalTransferPreSetupUseCaseTest: XCTestCase {
    var dependencies: PLInternalTransferOperativeExternalDependenciesResolver!
    private var mockDataInjector = MockDataInjector()
    private var sut: PLInternalTransferPreSetupUseCase!
    private var globalPositionMock: GlobalPositionRepresentable!
    private var polandAccount: PolandAccountRepresentable!
    private var notPolandAccount: AccountRepresentable!
    var notOriginCreditCardAccount: [AccountRepresentable] = []
    var accounts: [AccountRepresentable] = []
    override func setUp() {
        self.registrationManyAccounts()
        globalPositionMock = self.getGlobalPositionMock()
        dependencies = PLInternalTransferExternalDependenciesResolverMock()
        self.sut = PLInternalTransferPreSetupUseCase(dependencies: dependencies)
        accounts = globalPositionMock.accounts.map { entity in
            entity.representable
        }
    }
    
    func test_Given_NotPolandAccounts_Then_61_ONEAPP_OWN_CURRENCY_TRANSACTION() {
        accounts.forEach { account in
            let polandAccount = account as? PolandAccountRepresentable
            if polandAccount?.type != .creditCard {
                notOriginCreditCardAccount.append(account)
            }
        }
        let value = sut.creditCardAccountConditions(notOriginCreditCardAccount)
        XCTAssertTrue(value == true)
    }
}

private extension PLInternalTransferPreSetupUseCaseTest {
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
