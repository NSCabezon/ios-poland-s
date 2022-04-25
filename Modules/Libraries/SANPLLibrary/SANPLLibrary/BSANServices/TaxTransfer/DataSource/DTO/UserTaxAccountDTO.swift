//
//  UserTaxAccountDTO.swift
//  SANPLLibrary
//
//  Created by 185167 on 12/04/2022.
//

public struct UserTaxAccountDTO: Codable, Equatable {
    public let number: String
    public let id: String
    public let systemId: Int
    public let taxAccountId: String
    public let currencyCode: String
    public let name: AccountName
    public let type: AccountForPolandTypeDTO
    public let balance: MoneyDTO?
    public let availableFunds: MoneyDTO?
    public let lastUpdate: String
    
    public struct AccountName: Codable, Equatable {
        public let source: String
        public let description: String
        public let userDefined: String
    }
}
