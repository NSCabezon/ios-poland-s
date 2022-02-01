//
//  TaxPayersMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 11/01/2022.
//

import SANPLLibrary

protocol TaxPayersMapping {
    func map(_ payers: TaxPayerDTO) -> TaxPayer
}

final class TaxPayersMapper: TaxPayersMapping {
    func map(_ payer: TaxPayerDTO) -> TaxPayer {
        return TaxPayer(
            shortName: payer.shortName,
            name: payer.name,
            taxIdentifier: payer.taxNumber,
            secondaryTaxIdentifierNumber: payer.idNumber,
            idType: getIdType(payer: payer)
        )
    }
    
    private func getIdType(payer: TaxPayerDTO) -> TaxPayer.IdentifierType {
        switch payer.idType {
        case .closed:
            return .closed
        case .nationalBusinessRegistryNumber:
            return .nationalBusinessRegistryNumber
        case .nationalIdentityCard:
            return .nationalIdentityCard
        case .other:
            return .other
        case .passport:
            return .passport
        case .socialSecurityNumber:
            return .socialSecurityNumber
        case .taxPayerIdentificationNumber:
            return .taxPayerIdentificationNumber
        }
    }
}
