//
//  TaxPayer.swift
//  TaxTransfer
//
//  Created by 187831 on 11/01/2022.
//

import SANPLLibrary

public struct TaxPayer: Equatable {
    let identifier: Int
    let shortName: String
    let name: String?
    let taxIdentifier: String?
    let secondaryTaxIdentifierNumber: String
    let idType: IdentifierType
    
    public enum IdentifierType {
        case nationalIdentityCard
        case passport
        case other
        case socialSecurityNumber
        case taxPayerIdentificationNumber
        case nationalBusinessRegistryNumber
        case closed
        
        var displayableValue: String {
            switch self {
            case .nationalIdentityCard:
                return "#Dowód osobisty"
            case .passport:
                return "#Paszport"
            case .other:
                return "#Inny"
            case .socialSecurityNumber:
                return "#PESEL"
            case .taxPayerIdentificationNumber:
                return "#NIP"
            case .nationalBusinessRegistryNumber:
                return "#REGON"
            case .closed:
                return "#Zamknięty"
            }
        }
    }
    
    public static func ==(rhs: TaxPayer, lhs: TaxPayer) -> Bool {
        return rhs.taxIdentifier == lhs.taxIdentifier ||
            rhs.taxIdentifier == lhs.secondaryTaxIdentifierNumber ||
            rhs.secondaryTaxIdentifierNumber == lhs.taxIdentifier
    }
}
