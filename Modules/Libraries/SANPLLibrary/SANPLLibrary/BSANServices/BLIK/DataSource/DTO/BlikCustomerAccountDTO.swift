//
//  BlikCustomerAccountDTO.swift
//  SANPLLibrary
//
//  Created by 185167 on 26/10/2021.
//

public struct BlikCustomerAccountDTO: Codable {
    public let number: String
    public let id: String
    public let currencyCode: String
    public let name: Name
    public let balance: Amount
    public let availableFunds: Amount
    public let systemId: Int
    public let defaultForPayments: Bool
    public let defaultForP2P: Bool
    
    public struct Name: Codable {
        public let source: String
        public let description: String
        public let userDefined: String
    }
    
    public struct Amount: Codable {
        public let value: Decimal
        public let currencyCode: String
    }
}

