//
//  TaxTransferFormValidity.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

enum TaxTransferFormValidity: Equatable {
    case valid
    case invalid(InvalidFormMessages)
    
    struct InvalidFormMessages: Equatable {
        let amountMessage: String?
        let obligationIdentifierMessage: String?
    }
}
