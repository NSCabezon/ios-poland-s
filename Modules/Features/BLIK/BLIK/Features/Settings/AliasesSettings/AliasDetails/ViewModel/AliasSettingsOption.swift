//
//  AliasSettingsOption.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 03/09/2021.
//

enum AliasSettingsOption: CaseIterable {
    case changeAliasName
    case setValidityPeriod
    case delete
    
    var name: String {
        switch self {
        case .changeAliasName:
            return "#Zmień nazwę"
        case .setValidityPeriod:
            return "#Ustaw ważność"
        case .delete:
            return "#Usuń"
        }
    }
}
