//
//  AccountDetailDTO.swift
//  SANPLLibrary
//

import Foundation

public struct AccountDetailDTO: Codable {
    public let number: String?
    public let id: String?
    public let taxAccountId: String?
    public let currencyCode: String?
    public let name: AccountDetailNameDTO?
    public let type: String?
    public let balance: BalanceDTO?
    public let availableFunds: BalanceDTO?
    public let lastUpdate: String?
    public let systemId: Int?
    public let permissions: [String]?
    public let defaultForPayments: Bool?
    public let role: String?
    public let accountDetails: AccountDetailAccountDetailsDTO?
}

public struct AccountDetailNameDTO: Codable {
    public let source: String?
    public let description: String?
    public let userDefined: String?
}

public struct AccountDetailAccountDetailsDTO: Codable {
    public let openedDate: String?
    public let interestRate: Int?
    public let overDraftLimit: BalanceDTO?
    public let productCode: String?
    public let accountType: String?
}
