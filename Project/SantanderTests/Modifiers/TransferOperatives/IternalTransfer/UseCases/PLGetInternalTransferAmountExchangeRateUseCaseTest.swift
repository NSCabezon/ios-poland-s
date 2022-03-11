//
//  PLGetInternalTransferAmountExchangeRateUseCaseTest.swift
//  SantanderTests
//
//  Created by Mario Rosales Maillo on 10/3/22.
//

import Foundation
import XCTest
import SANPLLibrary
import CoreDomain
import OpenCombine
import UnitTestCommons
import TransferOperatives
@testable import Santander

class PLGetInternalTransferAmountExchangeRateUseCaseTest: XCTestCase {
    private var useCase: PLGetInternalTransferAmountExchangeRateUseCase!

    override func setUpWithError() throws {
        let rates = [ExchangeRateRepresentableMock(currency: CurrencyType.złoty.rawValue,
                                                   currencySymbol: "", buyRate: 0.0, sellRate: 0.0, decPlaces: 0),
                     ExchangeRateRepresentableMock(currency: CurrencyType.eur.rawValue,
                                                   currencySymbol: "", buyRate: 0.0, sellRate: 1.888, decPlaces: 0),
                     ExchangeRateRepresentableMock(currency: CurrencyType.dollar.rawValue,
                                                   currencySymbol: "", buyRate: 4.55, sellRate: 0.0, decPlaces: 0)]
        useCase = PLGetInternalTransferAmountExchangeRateUseCase(dependencies: PLInternalTransferExternalDependenciesResolverMock(rates: rates))
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_PLGetInternalTransferAmountExchangeRateUseCase_whenSameCurrency_rateShouldBeOne() throws {
        let input = GetInternalTransferAmountExchangeRateUseCaseInput(localCurrency: .złoty,
                                                                      initialCurrency: .złoty,
                                                                      targetCurrency: .złoty)
        let output = try useCase.fetchExchangeRate(input: input).sinkAwait()
        switch output {
        case .success(let exchangeRate):
            XCTAssert(exchangeRate.sellRate == 1.0)
        case .failure:
            XCTFail("PLGetInternalTransferAmountExchangeRateUseCaseTest: throw")
        }
    }
    
    func test_PLGetInternalTransferAmountExchangeRateUseCase_whenLocalCurrency_toForeingCurrency_sellRateShouldMatch() throws {
        let input = GetInternalTransferAmountExchangeRateUseCaseInput(localCurrency: .złoty,
                                                                      initialCurrency: .złoty,
                                                                      targetCurrency: .eur)
        let output = try useCase.fetchExchangeRate(input: input).sinkAwait()
        switch output {
        case .success(let exchangeRate):
            XCTAssert(exchangeRate.sellRate == 1.888)
        case .failure:
            XCTFail("PLGetInternalTransferAmountExchangeRateUseCaseTest: throw")
        }
    }
    
    func test_PLGetInternalTransferAmountExchangeRateUseCase_whenForeingCurrency_toForeingCurrency_sellRate_andBuyRate_ShouldMatch() throws {
        let input = GetInternalTransferAmountExchangeRateUseCaseInput(localCurrency: .złoty,
                                                                  initialCurrency: .eur,
                                                                  targetCurrency: .dollar)
        let output = try useCase.fetchExchangeRate(input: input).sinkAwait()
        switch output {
        case .success(let exchangeRate):
            XCTAssert(exchangeRate.sellRate == 1.888)
            XCTAssert(exchangeRate.buyRate == 4.55)
        case .failure:
            XCTFail("PLGetInternalTransferAmountExchangeRateUseCaseTest: throw")
        }
    }
    
    func test_PLGetInternalTransferAmountExchangeRateUseCase_missingCurrencyRate_ShouldFail() throws {
        let input = GetInternalTransferAmountExchangeRateUseCaseInput(localCurrency: .złoty,
                                                                  initialCurrency: .eur,
                                                                  targetCurrency: .pound)
        let output = try useCase.fetchExchangeRate(input: input).sinkAwait()
        switch output {
        case .success(_):
            XCTFail("PLGetInternalTransferAmountExchangeRateUseCaseTest: erroneous success")
        case .failure:
            XCTAssert(true)
        }
    }
}
