import XCTest
import CoreDomain
import CoreTestData
import TransferOperatives
import SANLegacyLibrary
import SANPLLibrary
@testable import Santander

final class PLGetInternalTransferOriginAccountsUseCaseTest: XCTestCase {
    private var mockDataInjector = MockDataInjector()
    var sut: PLGetInternalTransferOriginAccountsUseCase!
    var dependencies: PLInternalTransferOperativeExternalDependenciesResolver!
    
    override func setUp() {
        super.setUp()
        registrationManyAccounts()
        dependencies = PLInternalTransferExternalDependenciesResolverMock()
        sut = PLGetInternalTransferOriginAccountsUseCase(dependencies: dependencies)
    }
    
    func test_Given_NoAccountsProvidedAsInput_When_LaunchingTheUseCase_Then_UseCaseAnswersWithEmptyLists() throws {
        let input = GetInternalTransferOriginAccountsUseCaseInput(visibleAccounts: [], notVisibleAccounts: [])
        
        let response = try sut.filterAccounts(input: input).sinkAwait()
        
        XCTAssert(response.visiblesFiltered.isEmpty)
        XCTAssert(response.notVisiblesFiltered.isEmpty)
    }
    
    func test_Given_AllAccountsProvidedAreNonCreditCard_When_LaunchingTheUseCase_Then_UseCaseAnswersWithAllAccountsProvided() throws {
        let accounts: [PolandAccountRepresentableMock] = mockDataInjector.loadFromFile("PolandAccountsWithoutCreditCard")

        let input = GetInternalTransferOriginAccountsUseCaseInput(visibleAccounts: Array(accounts[0..<accounts.count / 2]), notVisibleAccounts: Array(accounts[accounts.count / 2..<accounts.count]))
        
        let response = try sut.filterAccounts(input: input).sinkAwait()
        
        XCTAssertFalse(response.visiblesFiltered.isEmpty)
        XCTAssertFalse(response.notVisiblesFiltered.isEmpty)
        XCTAssertEqual((response.visiblesFiltered + response.notVisiblesFiltered).count, accounts.count)
    }
    
    func test_Given_OnlyOneAccountIsNonCreditCard_When_LaunchingTheUseCase_Then_UseCaseAnswersWithOnlyTheCreditCardAccounts() throws {
        let accounts: [PolandAccountRepresentableMock] = mockDataInjector.loadFromFile("PolandAccountsWithOneNonCreditCard")

        let input = GetInternalTransferOriginAccountsUseCaseInput(visibleAccounts: Array(accounts[0..<accounts.count / 2]), notVisibleAccounts: Array(accounts[accounts.count / 2..<accounts.count]))
        
        let response = try sut.filterAccounts(input: input).sinkAwait()
        
        XCTAssertFalse(response.visiblesFiltered.isEmpty)
        XCTAssertFalse(response.notVisiblesFiltered.isEmpty)
        XCTAssertEqual((response.visiblesFiltered + response.notVisiblesFiltered).count, accounts.count - 1)
    }
    
    func test_Given_SeveralAccountTypesAreProvided_When_LaunchingTheUseCase_Then_UseCaseAnswersWithAllTheDifferentAccounts() throws {
        let accounts: [PolandAccountRepresentableMock] = mockDataInjector.loadFromFile("PolandAccountsWithSeveralNonCreditCard")

        let input = GetInternalTransferOriginAccountsUseCaseInput(visibleAccounts: Array(accounts[0..<accounts.count / 2]), notVisibleAccounts: Array(accounts[accounts.count / 2..<accounts.count]))
        
        let response = try sut.filterAccounts(input: input).sinkAwait()
        
        XCTAssertFalse(response.visiblesFiltered.isEmpty)
        XCTAssertFalse(response.notVisiblesFiltered.isEmpty)
        XCTAssertEqual((response.visiblesFiltered + response.notVisiblesFiltered).count, accounts.count)
    }
    
    func test_Given_SeveralAccountTypesAreProvided_When_LaunchingTheUseCaseAndOneAccountDoesntHaveAnIBAN_Then_UseCaseShouldAnswerWithAllTheAccounts() throws {
        let accounts: [PolandAccountRepresentableMock] = mockDataInjector.loadFromFile("PolandAccountsWithSeveralNonCreditCardErrorAnswer")

        let input = GetInternalTransferOriginAccountsUseCaseInput(visibleAccounts: Array(accounts[0..<accounts.count / 2]), notVisibleAccounts: Array(accounts[accounts.count / 2..<accounts.count]))
        
        let response = try sut.filterAccounts(input: input).sinkAwait()
        
        XCTAssertFalse(response.visiblesFiltered.isEmpty)
        XCTAssertFalse(response.notVisiblesFiltered.isEmpty)
        XCTAssert((response.visiblesFiltered + response.notVisiblesFiltered).count == accounts.count)
    }
    
    func test_Given_NonCreditCardAccountsNotPLNProvided_When_LaunchingTheUseCase_Then_UseCaseFiltersTheCreditCardAccounts() throws {
        let accounts: [PolandAccountRepresentableMock] = mockDataInjector.loadFromFile("PolandAccountsWithNonCreditCardNotPLN")

        let input = GetInternalTransferOriginAccountsUseCaseInput(visibleAccounts: accounts, notVisibleAccounts: [])
        
        let response = try sut.filterAccounts(input: input).sinkAwait()
        
        XCTAssertFalse(response.visiblesFiltered.isEmpty)
        XCTAssertEqual((response.visiblesFiltered + response.notVisiblesFiltered).count, accounts.count - 3)
    }
}

private extension PLGetInternalTransferOriginAccountsUseCaseTest {
    func registrationManyAccounts() {
        mockDataInjector.register(
            for: \.gpData.getGlobalPositionMock,
            filename: "PLobtenerPosGlobal"
        )
    }

    func getGlobalPositionMock() -> GlobalPositionMock {
        return GlobalPositionMock(
            mockDataInjector.mockDataProvider.gpData.getGlobalPositionMock,
            cardsData: [:],
            temporallyOffCards: [:],
            inactiveCards: [:],
            cardBalances: [:]
            )
    }
}

struct PolandAccountRepresentableMock: Codable, PolandAccountRepresentable {
    var currencyDto: CurrencyDTO?
    var iban: IBANDTO?
    var type: AccountForPolandTypeDTO?
    var sequencerNo: Int? { nil }
    var accountType: Int? { nil }
    var currencyName: String? { nil }
    var alias: String? { nil }
    var currentBalanceRepresentable: AmountRepresentable? { nil }
    var ibanRepresentable: IBANRepresentable? { iban }
    var contractNumber: String? { nil }
    var contractRepresentable: ContractRepresentable? { nil }
    var isMainAccount: Bool? { nil }
    var currencyRepresentable: CurrencyRepresentable? { currencyDto }
    var currencyCode: String? { currencyDto?.currencyCode }
    var getIBANShort: String { "" }
    var getIBANPapel: String { "" }
    var getIBANString: String { "" }
    var situationType: String? { nil }
    var availableAmountRepresentable: AmountRepresentable? { nil }
    var availableNoAutAmountRepresentable: AmountRepresentable? { nil }
    var overdraftRemainingRepresentable: AmountRepresentable? { nil }
    var earningsAmountRepresentable: AmountRepresentable? { nil }
    var productSubtypeRepresentable: ProductSubtypeRepresentable? { nil }
    var countervalueCurrentBalanceAmountRepresentable: AmountRepresentable? { nil }
    var countervalueAvailableNoAutAmountRepresentable: AmountRepresentable? { nil }
    var ownershipTypeDesc: OwnershipTypeDesc? { nil }
    var tipoSituacionCto: String? { nil }
    func equalsTo(other: AccountRepresentable?) -> Bool {
        return true
    }
}
