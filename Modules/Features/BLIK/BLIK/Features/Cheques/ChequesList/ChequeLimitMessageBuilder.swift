//
//  ChequeLimitMessageBuilder.swift
//  Account
//
//  Created by 187831 on 17/11/2021.
//

import CoreFoundationLib

final class ChequeLimitMessageBuilder {
    private var limit: Int = 0
    
    func withLimit(_ limit: Int) -> Self {
        self.limit = limit
        return self
    }
    
    func build() -> LocalizedStylableText {
        switch limit {
        case 1:
            return localized("pl_blik_alert_chequeLimitText1", [StringPlaceholder(.value, "\(limit)")])
        case 2...4:
            return localized("pl_blik_alert_chequeLimitText24", [StringPlaceholder(.value, "\(limit)")])
        default:
            return localized("pl_blik_alert_chequeLimitText5", [StringPlaceholder(.value, "\(limit)")])
        }
    }
}
