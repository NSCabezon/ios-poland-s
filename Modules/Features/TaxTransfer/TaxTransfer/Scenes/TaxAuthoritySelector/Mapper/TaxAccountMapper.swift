//
//  TaxAccountMapper.swift
//  TaxTransfer
//
//  Created by 185167 on 16/03/2022.
//

import SANPLLibrary

protocol TaxAccountMapping {
    func map(_ taxAccount: TaxAccountDTO) throws -> TaxAccount
}

final class TaxAccountMapper: TaxAccountMapping {
    enum Error: Swift.Error {
        case incorrectDateFormat
    }
    
    private let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    func map(_ taxAccount: TaxAccountDTO) throws -> TaxAccount {
        guard
            let validFromDate = dateFormatter.date(from: taxAccount.validFrom),
            let validToDate = dateFormatter.date(from: taxAccount.validTo)
        else {
            throw Error.incorrectDateFormat
        }
        
        return TaxAccount(
            accountNumber: taxAccount.number,
            address: TaxAccount.Address(
                street: taxAccount.address.street,
                city: taxAccount.address.city,
                zipCode: taxAccount.address.zipCode
            ),
            accountName: taxAccount.name,
            taxFormType: taxAccount.taxFormType,
            validFromDate: validFromDate,
            validToDate: validToDate,
            isActive: taxAccount.active
        )
    }
}
