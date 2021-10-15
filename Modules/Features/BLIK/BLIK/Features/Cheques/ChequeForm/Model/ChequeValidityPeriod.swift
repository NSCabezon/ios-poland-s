//
//  ChequeValidityPeriod.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 13/07/2021.
//

import UI
import Commons

enum ChequeValidityPeriod: Int, CaseIterable {
    case hours24 = 24
    case hours48 = 48
    case hours72 = 72
    
    var stringDescription: String {
        switch self {
        case .hours24:
            return localized("pl_blik_text_hour_24")
        case .hours48:
            return localized("pl_blik_text_hour_48")
        case .hours72:
            return localized("pl_blik_text_hour_72")
        }
    }
}

extension ChequeValidityPeriod: DropdownElement {
    var name: String {
        return self.stringDescription
    }
}
