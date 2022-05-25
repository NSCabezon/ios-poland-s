//
//  PLGetAccountsFullNameUseCaseTest.swift
//  SantanderTests
//
//  Created by Carlos Monfort Gómez on 24/5/22.
//

import Foundation
import XCTest
import CoreDomain
import OpenCombine
import TransferOperatives
import CoreTestData
import CoreFoundationLib
@testable import Santander

class PLGetAccountsFullNameUseCaseTest: XCTestCase {
    private var sut: PLGetAccountsFullNameUseCase!
    private var mockDataInjector: MockDataInjector!
    
    override func setUpWithError() throws {
        sut = PLGetAccountsFullNameUseCase(dependencies: PLInternalTransferExternalDependenciesResolverMock())
        mockDataInjector = MockDataInjector()
        registerAccounts()
    }
    
    func test_Given_ThereIsANotIbanAccountThatIsWellFormatted_When_UseCaseIsExecuted_Then_GetFullNameIsCorrect() throws {
        // G
        let notIbanAccount = getAccount(0)
        // W
        let value = try sut.fetchAccountsFullName(notIbanAccount)
            .replaceError(with: GetAccountsFullNameUseCaseOutput(fullName: nil))
            .map { $0.fullName }
            .sinkAwait()
        // T
        XCTAssertNotNil(value)
    }
    
    func test_Given_ThereIsAnIbanAccountThatIsWellFormatted_When_UseCaseIsExecuted_Then_GetFullNameIsCorrect() throws {
        // G
        let ibanAccount = getAccount(1)
        // W
        let value = try sut.fetchAccountsFullName(ibanAccount)
            .replaceError(with: GetAccountsFullNameUseCaseOutput(fullName: nil))
            .map { $0.fullName }
            .sinkAwait()
        // T
        XCTAssertNotNil(value)
    }
    
    func test_Given_ThereIsANotIbanAccountThatIsWrongFormatted_When_UseCaseIsExecuted_Then_GetFullNameIsNil() throws {
        // G
        let notIbanAccount = getAccount(2)
        // W
        let value = try sut.fetchAccountsFullName(notIbanAccount)
            .replaceError(with: GetAccountsFullNameUseCaseOutput(fullName: nil))
            .map { $0.fullName }
            .sinkAwait()
        // T
        XCTAssertNil(value)
    }
    
    func test_Given_ThereIsAnIbanAccountThatIsWrongFormatted_When_UseCaseIsExecuted_Then_GetFullNameIsNil() throws {
        // G
        let ibanAccount = getAccount(3)
        // W
        let value = try sut.fetchAccountsFullName(ibanAccount)
            .replaceError(with: GetAccountsFullNameUseCaseOutput(fullName: nil))
            .map { $0.fullName }
            .sinkAwait()
        // T
        XCTAssertNil(value)
    }
    
    func test_Given_ThereIsAnAccountWithoutIban_When_UseCaseIsExecuted_Then_GetFullNameIsNil() throws {
        // G
        let account = getAccountWithoutIban()
        // W
        let value = try sut.fetchAccountsFullName(account)
            .replaceError(with: GetAccountsFullNameUseCaseOutput(fullName: nil))
            .map { $0.fullName }
            .sinkAwait()
        // T
        XCTAssertNil(value)
    }
}

private extension PLGetAccountsFullNameUseCaseTest {
    func registerAccounts() {
        self.mockDataInjector.register(
            for: \.accountData.getAllAccountsMock,
            filename: "getAccountsForFullName"
        )
    }
    
    func getAccount(_ index: Int) -> AccountRepresentable {
        let accounts: [AccountRepresentable] = mockDataInjector.mockDataProvider.accountData.getAllAccountsMock.map {
            AccountEntity($0).representable
        }
        return accounts[index]
    }
    
    func getAccountWithoutIban() -> AccountRepresentable {
        return AccountRepresentedMock()
    }
}

private struct AccountRepresentedMock: AccountRepresentable {
    var currencyName: String?
    var alias: String?
    var currentBalanceRepresentable: AmountRepresentable?
    var ibanRepresentable: IBANRepresentable?
    var contractNumber: String?
    var contractRepresentable: ContractRepresentable?
    var isMainAccount: Bool?
    var currencyRepresentable: CurrencyRepresentable?
    var getIBANShort: String
    var getIBANPapel: String
    var getIBANString: String
    var situationType: String?
    var availableAmountRepresentable: AmountRepresentable?
    var availableNoAutAmountRepresentable: AmountRepresentable?
    var overdraftRemainingRepresentable: AmountRepresentable?
    var earningsAmountRepresentable: AmountRepresentable?
    var productSubtypeRepresentable: ProductSubtypeRepresentable?
    var countervalueCurrentBalanceAmountRepresentable: AmountRepresentable?
    var countervalueAvailableNoAutAmountRepresentable: AmountRepresentable?
    var ownershipTypeDesc: OwnershipTypeDesc?
    var tipoSituacionCto: String?
    
    init() {
        self.getIBANShort = ""
        self.getIBANPapel = ""
        self.getIBANString = ""
    }
    
    func equalsTo(other: AccountRepresentable?) -> Bool {
        return false
    }
}
