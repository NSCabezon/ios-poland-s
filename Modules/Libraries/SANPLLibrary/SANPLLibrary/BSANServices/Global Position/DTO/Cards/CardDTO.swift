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
    public let availableBalance: CardAvailableBalanceDTO?
    public let creditLimit: CardCreditLimitDTO?
    public let disposedAmount: CardDisposedAmountDTO?
}

public struct CardNameDTO: Codable {
    public let description: String?
    public let userDefined: String?
}

public struct CardAvailableBalanceDTO: Codable {
    public let value: Double?
    public let currencyCode: String?
}

public struct CardCreditLimitDTO: Codable {
    public let value: Double?
    public let currencyCode: String?
}

public struct CardDisposedAmountDTO: Codable {
    public let value: Double?
    public let currencyCode: String?
}
