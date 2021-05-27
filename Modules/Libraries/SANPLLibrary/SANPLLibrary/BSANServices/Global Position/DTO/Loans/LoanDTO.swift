//
//  LoanDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanDTO: Codable {
    public let number: String?
    public let accountId: LoanAccountIdDTO?
    public let currencyCode: String?
    public let name: LoanNameDTO?
    public let role: String?
    public let type: String?
    public let currentLimit: BalanceDTO?
    public let lastUpdate: String?
}

public struct LoanAccountIdDTO: Codable {
    public let id: String?
    public let systemId: Int?
}

public struct LoanNameDTO: Codable {
    public let description: String?
    public let userDefined: String?
}
