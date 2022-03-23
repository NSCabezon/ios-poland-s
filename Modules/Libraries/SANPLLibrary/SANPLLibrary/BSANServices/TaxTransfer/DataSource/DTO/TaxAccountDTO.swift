//
//  TaxAccountDTO.swift
//  SANPLLibrary
//
//  Created by 185167 on 15/03/2022.
//

public struct TaxAccountDTO: Codable, Equatable {
    public let number: String
    public let address: Address
    public let name: String
    public let taxFormType: Int
    public let validFrom: String
    public let validTo: String
    public let active: Bool
    
    public struct Address: Codable, Equatable {
        public let street: String
        public let city: String
        public let zipCode: String
    }
}
