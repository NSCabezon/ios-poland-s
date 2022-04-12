//
//  TaxItemSelectorType.swift
//  TaxTransfer
//
//  Created by 187831 on 10/02/2022.
//

import CoreFoundationLib

enum TaxTransferParticipantSelectorType {
    case payer
    case payee
    
    var title: String {
        switch self {
        case .payer:
            return localized("pl_toolbar_title_Payee")
        case .payee:
            return localized("pl_toolbar_taxAuthority")
        }
    }
    
    var info: String {
        switch self {
        case .payer:
            return localized("pl_taxTransfer_text_payeesList")
        case .payee:
            return localized("pl_taxTransfer_text_taxAuthoritiesDescription")
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .payer:
            return localized("pl_taxTransfer_button_choosePayee")
        case .payee:
            return localized("pl_taxTransfer_button_chooseTaxAuthority")
        }
    }
}
