//
//  AliasSettingsOption.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 03/09/2021.
//
import Commons

enum AliasSettingsOption: CaseIterable {
    case changeAliasName
    case setValidityPeriod
    case delete
    
    var name: String {
        switch self {
        case .changeAliasName:
            return localized("pl_blik_text_changeNameDevice")
        case .setValidityPeriod:
            return localized("pl_blik_text_setDateExpir")
        case .delete:
            return localized("pl_blik_text_deleteDevice")
        }
    }
}
