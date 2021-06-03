//
//  CardsDTO.swift
//  SANPLLibrary
//
//  Created by Francisco Perez Martinez on 14/5/21.
//

import Foundation

public struct CardDTO: Codable {
    public let maskedPan: String?
    public let virtualPan: String?
    public let generalStatus: String?
    public let cardStatus: String?
    public let role: String?
    public let type: String?
    public let productCode: String?
    public let name: CardNameDTO?
    public let relatedAccount: String?
    public let expirationDate: String?
    public let availableBalance: BalanceDTO?
    public let creditLimit: BalanceDTO?
    public let disposedAmount: BalanceDTO?
}

public struct CardNameDTO: Codable {
    public let description: String?
    public let userDefined: String?
}