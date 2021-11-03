//
//  AliasDateValidityPeriod.swift
//  BLIK
//
//  Created by 186491 on 22/09/2021.
//

import UI
import Commons

enum AliasDateValidityPeriod: Int, CaseIterable {
    case month1 = 1
    case month3 = 3
    case month6 = 6
    case month12 = 12
    
    var stringDescription: String {
        switch self {
        case .month1:
            return localized("pl_blik_text_month_1")
        case .month3:
            return localized("pl_blik_text_month_3")
        case .month6:
            return localized("pl_blik_text_month_6")
        case .month12:
            return localized("pl_blik_text_month_12")
        }
    }
}

extension AliasDateValidityPeriod: DropdownElement {
    var name: String {
        return self.stringDescription
    }
}
