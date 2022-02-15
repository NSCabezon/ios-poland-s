//
//  TaxAuthorityMapper.swift
//  TaxTransfer
//
//  Created by 185167 on 03/02/2022.
//

import SANPLLibrary

protocol TaxAuthorityMapping {
    func map(_ payee: PayeeDTO) throws -> TaxAuthority
}

final class TaxAuthorityMapper: TaxAuthorityMapping {
    enum Error: Swift.Error {
        case missingData
    }
    
    func map(_ payee: PayeeDTO) throws -> TaxAuthority {
        guard
            let identifier = payee.payeeId,
            let name = payee.payeeDisplayName,
            let accountNumber = payee.account?.accountNo
        
        else {
            throw Error.missingData
        }
        
        return TaxAuthority(
            id: identifier,
            name: name,
            accountNumber: accountNumber
        )
    }
}
