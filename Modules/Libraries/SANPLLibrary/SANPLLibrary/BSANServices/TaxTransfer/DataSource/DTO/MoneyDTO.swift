//
//  MoneyDTO.swift
//  SANPLLibrary
//
//  Created by 185167 on 12/04/2022.
//

public struct MoneyDTO: Codable, Equatable {
    public let value: Decimal
    public let currencyCode: String
}
