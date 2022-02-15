//
//  AccountDTO.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 13/5/21.
//

import Foundation

public struct AccountDTO: Codable {
    public struct AccountNameDTO: Codable {
        public let description: String?
        public let userDefined: String?
    }

    public struct AccountIdDTO: Codable {
        public let id: String?
        public let systemId: Int?
    }
    
    public let defaultForPayments: Bool?
    public let number: String?
    public let name: AccountNameDTO?
    public let accountId: AccountIdDTO?
    public let productId: AccountIdDTO?
    public let type: String?
    public let balance: BalanceDTO?
    public let availableFunds: BalanceDTO?
    public let withholdingBalance: BalanceDTO?
    public let overDraftLimit: BalanceDTO?
    public let currencyCode: String?
    public let role: String?
    public let lastUpdate: String?
}
