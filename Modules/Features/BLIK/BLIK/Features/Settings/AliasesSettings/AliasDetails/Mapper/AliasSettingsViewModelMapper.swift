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
        let expirationDate = localized(
            "pl_blik_expirDateDevice",
            [StringPlaceholder(.value, dateFormatter.string(from: alias.expirationDate))]
        ).text
        return AliasSettingsViewModel(
            aliasName: alias.label,
            expirationDate: expirationDate,
            settingsOptions: AliasSettingsOption.allCases
        )
    }
}
