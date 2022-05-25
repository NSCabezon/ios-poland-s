//
//  ExchangeRatesDTO.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 4/3/22.
//

import CoreDomain
import CoreFoundationLib

public struct ExchangeRatesDTO: Codable {
    public let exRates: [ExchangeRateDTO]
}

public struct ExchangeRateDTO: Codable {
    public let currency: String
    public let currencySymbol: String
    public let currencyUnit: Int
    public let midRate: Decimal
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
        return foreignCurrencyRate.buyRate / Decimal(currencyUnit)
    }

    public var sellRate: Decimal {
        return foreignCurrencyRate.sellRate / Decimal(currencyUnit)
    }
    
    public var currencyCode: String { currency }
    
    public var buyRateRepresentable: AmountRepresentable {
        AmountRepresented(value: buyRate, currencyRepresentable: CurrencyRepresented(currencyCode: "PLN"))
    }
    
    public var sellRateRepresentable: AmountRepresentable {
        AmountRepresented(value: sellRate, currencyRepresentable: CurrencyRepresented(currencyCode: "PLN"))
    }
}
