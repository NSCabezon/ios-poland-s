//
//  TaxIdentifierMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 02/03/2022.
//

protocol TaxIdentifierMapping {
    func map(_ identifier: TaxIdentifierType) -> TaxPayer.IdentifierType
    func map(_ identifier: TaxPayer.IdentifierType) -> TaxIdentifierType
}

final class TaxIdentifierMapper: TaxIdentifierMapping {
    func map(_ identifier: TaxIdentifierType) -> TaxPayer.IdentifierType {
        switch identifier {
        case .ID:
            return .nationalIdentityCard
        case .NIP:
            return .taxPayerIdentificationNumber
        case .PESEL:
            return .socialSecurityNumber
        case .REGON:
            return .nationalBusinessRegistryNumber
        case .passport:
            return .passport
        case .other:
            return .other
        }
    }

    func map(_ identifier: TaxPayer.IdentifierType) -> TaxIdentifierType {
        switch identifier {
        case .nationalIdentityCard:
            return .ID
        case .taxPayerIdentificationNumber:
            return .NIP
        case .socialSecurityNumber:
            return .PESEL
        case .nationalBusinessRegistryNumber:
            return .REGON
        case .passport:
            return .passport
        case .other:
            return .other
        case .closed:
            return .other
        }
    }
}
