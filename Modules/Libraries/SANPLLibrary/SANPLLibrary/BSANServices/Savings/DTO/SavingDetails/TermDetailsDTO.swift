//
//  TermDetailsDTO.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 30/4/22.
//

import Foundation

public struct TermDetailsNameDTO: Codable {
    public let description: String?
    public let userDefined: String?
}

public struct TermDetailsTenorDTO: Codable {
    public let period: Int?
    public let unit: String?
}

public struct TermDepositRateData: Codable {
    public let interestRate: Decimal?
    public let interestRateURL: String?
    public let interestRateIndicator: String?
}

public struct TermBalance: Codable {
    public let currencyCode: String?
    public let value: Decimal?
}

public struct TermDetailsDTO: Codable {
    public let name: TermDetailsNameDTO?
    public let number: String?
    public let depositRateData: TermDepositRateData?
    public let currentBalance: TermBalance?
    public let renewal: Bool?
    public let interestCapitalization: Bool?
    public let openingDate: String?
    public let lastCapitalizationDate: String?
    public let nextCapitalizationDate: String?
    public let tenor: TermDetailsTenorDTO?
    public let interestRateIncreased: Bool?
}
