//
//  ExchangeRateRepresentableMock.swift
//  SantanderTests
//
//  Created by Mario Rosales Maillo on 10/3/22.
//

import Foundation
import SANPLLibrary

struct ExchangeRateRepresentableMock: ExchangeRateRepresentable {
    var currency: String
    var currencySymbol: String
    var buyRate: Decimal
    var sellRate: Decimal
    var decPlaces: Int
    
    public init(currency: String, currencySymbol: String, buyRate: Decimal, sellRate: Decimal, decPlaces: Int) {
        self.currency = currency
        self.currencySymbol = currencySymbol
        self.buyRate = buyRate
        self.sellRate = sellRate
        self.decPlaces = decPlaces
    }
}
