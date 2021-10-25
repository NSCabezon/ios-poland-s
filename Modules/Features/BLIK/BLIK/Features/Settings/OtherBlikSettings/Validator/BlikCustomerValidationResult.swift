//
//  BlikCustomerLabelValidationResult.swift
//  BLIK
//
//  Created by 185167 on 14/10/2021.
//

import Commons

enum BlikCustomerLabelValidationResult {
    case valid
    case invalid(InvalidityReason)
    
    enum InvalidityReason: Error {
        case illegalCharacters
        case emptyText
        case exceededMaximumLength
        
        var localizedString: String {
            switch self {
            case .illegalCharacters:
                return localized("pl_blikSett_text_validNoPermSings")
            case .emptyText:
                return localized("pl_blikSett_text_validEmptyField")
            case .exceededMaximumLength:
                return localized("pl_blikSett_text_validMaxAmountSing")
            }
        }
    }
}
