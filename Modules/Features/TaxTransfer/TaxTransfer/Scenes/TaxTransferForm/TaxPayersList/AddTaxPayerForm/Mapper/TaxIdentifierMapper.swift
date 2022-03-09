//
//  TaxIdentifierMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 02/03/2022.
//

protocol TaxIdentifierMapping {
    func map(_ identifier: TaxIdentifierType) -> TaxPayer.IdentifierType
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
}
