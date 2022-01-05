//
//  TaxTransferFormValidity.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

enum TaxTransferFormValidity {
    case valid
    case invalid(InvalidFormMessages)
    
    struct InvalidFormMessages {
        // TODO: Include possible invalid field meessages
    }
}
