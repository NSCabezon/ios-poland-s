//
//  ExchangeRatesRepresentable.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 4/3/22.
//

import Foundation
import CoreDomain

public protocol ExchangeRatesRepresentable {
    var exchangeRates: [ExchangeRateRepresentable] { get }
}

public protocol ExchangeRateRepresentable: CoreExchangeRateRepresentable {
    var currency: String { get }
    var currencySymbol: String { get }
    var buyRate: Decimal { get }
    var sellRate: Decimal { get }
    var decPlaces: Int { get }
}
