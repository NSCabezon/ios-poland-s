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
}
