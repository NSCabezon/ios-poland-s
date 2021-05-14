//
//  BalanceDTO.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 14/5/21.
//

import Foundation

public struct BalanceDTO: Codable {
    public let value: Double?
    public let currencyCode: String?
}
