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
@testable import SANPLLibrary
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
        registrationManyAccounts()
        globalPositionMock = self.getGlobalPositionMock()
        dependencies = PLInternalTransferExternalDependenciesResolverMock(rates: [], accounts: getAccountForDebit(), mockDataInjector: mockDataInjector)
        sut = PLInternalTransferPreSetupUseCase(dependencies: dependencies)
        accounts = globalPositionMock.accounts.map { entity in
            entity.representable
        }
    }
    
    func test_Given_EmptyAccounts_When_AllCases_Then_getEmptyAccountsError() throws {
        let value = try sut.fetchPreSetup().sinkAwaitError()
        XCTAssertTrue(value == .originMinimunAccounts)
    }
}

private extension PLInternalTransferPreSetupUseCaseTest {
    func registrationManyAccounts() {
        self.mockDataInjector.register(
            for: \.gpData.getGlobalPositionMock,
               filename: "PLobtenerPosGlobal"
        )
    }
    
    func getAccountForDebit() -> [AccountForDebitDTO] {
        return self.mockDataInjector.loadFromFile("emptyArrayResponse")
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
