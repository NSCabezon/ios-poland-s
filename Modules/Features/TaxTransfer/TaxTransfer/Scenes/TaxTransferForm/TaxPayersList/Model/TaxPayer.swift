//
//  TaxPayer.swift
//  TaxTransfer
//
//  Created by 187831 on 11/01/2022.
//

import SANPLLibrary
import CoreFoundationLib

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
                return localized("pl_generic_docId_nationaIdentityCard")
            case .passport:
                return localized("pl_generic_docId_passport")
            case .other:
                return localized("pl_generic_docId_other")
            case .socialSecurityNumber:
                return localized("pl_generic_docId_pesel")
            case .taxPayerIdentificationNumber:
                return localized("pl_generic_docId_nip")
            case .nationalBusinessRegistryNumber:
                return localized("pl_generic_docId_regon")
            case .closed:
                return localized("pl_generic_docId_closed")
            }
        }
    }
    
    public static func ==(rhs: TaxPayer, lhs: TaxPayer) -> Bool {
        return rhs.taxIdentifier == lhs.taxIdentifier ||
            rhs.taxIdentifier == lhs.secondaryTaxIdentifierNumber ||
            rhs.secondaryTaxIdentifierNumber == lhs.taxIdentifier
    }
}
