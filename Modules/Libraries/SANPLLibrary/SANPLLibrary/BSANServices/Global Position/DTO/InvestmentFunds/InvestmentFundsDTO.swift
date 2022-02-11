//
//  InvestmentFundsDTO.swift
//  SANPLLibrary
//

import Foundation

public struct InvestmentFundsDTO: Codable {
    public let number: String?
    public let accountId: InvestmentFundsAccountIdDTO?
    public let productId: InvestmentFundsAccountIdDTO?
    public let currencyCode: String?
    public let name: InvestmentFundsNameDTO?
    public let role: String?
    public let type: String?
    public let currentValue: BalanceDTO?
}

public struct InvestmentFundsAccountIdDTO: Codable {
    public let id: String?
    public let systemId: Int?
}

public struct InvestmentFundsNameDTO: Codable {
    public let source: String?
    public let userDefined: String?
}
