//
//  ExchangeRatesRepresentable.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 4/3/22.
//

import Foundation

public protocol ExchangeRatesRepresentable {
    var exchangeRates: [ExchangeRateRepresentable] { get }
}

public protocol ExchangeRateRepresentable {
    var currency: String { get }
    var currencySymbol: String { get }
    var buyRate: Double { get }
    var sellRate: Double { get }
    var decPlaces: Int { get }
}
