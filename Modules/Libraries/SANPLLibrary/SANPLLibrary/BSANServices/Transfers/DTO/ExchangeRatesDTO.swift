//
//  ExchangeRatesDTO.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 4/3/22.
//

import Foundation

public struct ExchangeRatesDTO: Codable {
    public let exRates: [ExchangeRateDTO]
}

public struct ExchangeRateDTO: Codable {
    public let currency: String
    public let currencySymbol: String
    public let currencyUnit: Int
    public let midRate: Double
    public let decPlaces: Int
    public let moneyRate: MoneyRateDTO
    public let foreignCurrencyRate: MoneyRateDTO
}

public struct MoneyRateDTO: Codable {
    public let buyRate: Decimal
    public let sellRate: Decimal
}

extension ExchangeRatesDTO: ExchangeRatesRepresentable {
    public var exchangeRates: [ExchangeRateRepresentable] {
        return exRates
    }
}

extension ExchangeRateDTO: ExchangeRateRepresentable {

    public var buyRate: Decimal {
        return foreignCurrencyRate.buyRate
    }

    public var sellRate: Decimal {
        foreignCurrencyRate.sellRate
    }
}
