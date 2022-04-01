//
//  TestPLCardDetailConfiguration.swift
//  Santander
//
//  Created by Gloria Cano López on 22/3/22.
//

import CoreTestData
import XCTest
import Cards
@testable import Santander

class TestGetPLCardDetailConfigurationUseCase: XCTestCase {
    lazy var dependencies: TestCardDetailDependencies = {
        let external = TestCardDetailExternalDependencies(injector: self.mockDataInjector, dependencies: AppDependencies().dependencieEngine)
        return TestCardDetailDependencies(injector: self.mockDataInjector,
                                          externalDependencies: external)
    }()
    var cardConfiguration: CardDetailConfiguration?
    lazy var mockDataInjector: MockDataInjector = {
        let injector = MockDataInjector()
        injector.register(
            for: \.gpData.getGlobalPositionMock,
               filename: "obtenerPosGlobal")
        injector.register(
            for: \.cardsData.getCardDetail,
               filename: "getCardDetail"
        )
        return injector
    }()
    
    func test_When_FetchConfiguration_Expect_ShowCardPANIsEnabled() throws {
        let sut = PLGetCardDetailConfigurationUseCase(dependenciesEngine: self.dependencies.external.resolve())
        
        _ = sut.fetchCardDetailConfiguration(card: MockCard(), cardDetail: MockCardDetail()).sink(receiveValue: { [unowned self] detail in
            cardConfiguration = detail
            
        })
        XCTAssert(cardConfiguration?.isShowCardPAN == false)
        XCTAssert(cardConfiguration?.isCardPANMasked == false)
        
    }
    
    func test_When_FetchConfiguration_Expect_HolderIsEnabled() throws {
        let sut = PLGetCardDetailConfigurationUseCase(dependenciesEngine: self.dependencies.external.resolve())
        
        _ = sut.fetchCardDetailConfiguration(card: MockCard(), cardDetail: MockCardDetail()).sink(receiveValue: { [unowned self] detail in
            cardConfiguration = detail
            
        })
        XCTAssert(cardConfiguration?.isCardHolderEnabled == true)
    }
    
    func test_When_FetchConfiguration_Expect_CardDetailElements() throws {
        let sut = PLGetCardDetailConfigurationUseCase(dependenciesEngine: self.dependencies.external.resolve())
        
        _ = sut.fetchCardDetailConfiguration(card: MockCard(), cardDetail: MockCardDetail()).sink(receiveValue: { [unowned self] detail in
            cardConfiguration = detail
            
        })
        XCTAssert(cardConfiguration?.creditCardHeaderElements == [.limitCredit, .availableCredit, .withdrawnCredit])
        XCTAssert(cardConfiguration?.debitCardHeaderElements == [])
        XCTAssert(cardConfiguration?.prepaidCardHeaderElements == [.availableBalance])
        XCTAssert(cardConfiguration?.cardDetailElements == [.pan, .alias, .holder, .linkedAccount, .status, .currency, .insurance])
    }
    
}
