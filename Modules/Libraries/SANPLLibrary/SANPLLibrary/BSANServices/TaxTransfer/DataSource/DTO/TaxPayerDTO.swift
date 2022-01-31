//
//  TaxPayerDTO.swift
//  TaxTransfer
//
//  Created by 187831 on 28/12/2021.
//

public struct TaxPayerDTO: Codable {
    public let sequenceNumber: Int
    public let shortName: String
    public let taxNumber: String?
    public let idType: IdentifierTypeDTO
    public let idNumber: String
    public let name: String?
    public let stamp: Int
    
    public enum IdentifierTypeDTO: String, Codable {
        case nationalIdentityCard = "NATIONAL_IDENTITY_CARD"
        case passport = "PASSPORT"
        case other = "OTHER"
        case socialSecurityNumber = "SOCIAL_SECURITY_NUMBER"
        case taxPayerIdentificationNumber = "TAXPAYER_IDENTIFICATION_NUMBER"
        case nationalBusinessRegistryNumber = "NATIONAL_BUSINESS_REGISTRY_NUMBER"
        case closed = "CLOSED"
    }
}
