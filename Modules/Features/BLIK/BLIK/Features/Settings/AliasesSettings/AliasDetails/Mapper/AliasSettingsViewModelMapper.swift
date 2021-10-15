//
//  AliasSettingsViewModelMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 03/09/2021.
//

import Commons

protocol AliasSettingsViewModelMapping {
    func map(_ alias: BlikAlias) -> AliasSettingsViewModel
}

final class AliasSettingsViewModelMapper: AliasSettingsViewModelMapping {
    private let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    func map(_ alias: BlikAlias) -> AliasSettingsViewModel {
        let expirationDate: String? = {
            guard let date = alias.expirationDate else {
                return nil
            }
            
            return localized("pl_blik_expirDateDevice", [StringPlaceholder(.value, dateFormatter.string(from: date))]).text
        }()
        return AliasSettingsViewModel(
            aliasName: alias.label,
            expirationDate: expirationDate,
            settingsOptions: AliasSettingsOption.allCases
        )
    }
}
