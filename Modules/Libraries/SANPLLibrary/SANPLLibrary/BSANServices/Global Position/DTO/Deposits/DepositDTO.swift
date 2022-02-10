//
//  DepositDTO.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 19/5/21.
//

import Foundation

public struct DepositDTO: Codable {
    public let number: String?
    public let name: DepositNameDTO?
    public let accountId: DepositIdDTO?
    public let productId: DepositIdDTO?
    public let type: String?
    public let currentBalance: BalanceDTO?
    public let currencyCode: String?
    public let role: String?
    public let lastUpdate: String?
}

public struct DepositNameDTO: Codable {
    public let userDefined: String?
    public let description: String?
}

public struct DepositIdDTO: Codable {
    public let id: String?
    public let systemId: Int?
}
