//
//  AliasListSettingsViewModelMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 02/09/2021.
//

import Commons
import UI

protocol AliasListSettingsViewModelMapping {
    func map(_ aliases: [BlikAlias]) -> [AliasListSettingsViewModel]
}

final class AliasListSettingsViewModelMapper: AliasListSettingsViewModelMapping {
    func map(_ aliases: [BlikAlias]) -> [AliasListSettingsViewModel] {
        let aliases = filterUnsupportedAliases(aliases)
        
        if aliases.isEmpty {
            return getEmptyDataViewModel()
        }
        
        var viewModels: [AliasListSettingsViewModel] = [.header(getHeaderMessage())]
        viewModels += aliases.map { getAliasViewModel(for: $0) }
        return viewModels
    }
    
    private func filterUnsupportedAliases(_ aliases: [BlikAlias]) -> [BlikAlias] {
        return aliases.filter { alias -> Bool in
            switch alias.type {
            case .internetBrowser, .internetShop:
                return true
            default:
                return false
            }
        }
    }
    
    private func getEmptyDataViewModel() -> [AliasListSettingsViewModel] {
        return [
            .emptyDataMessage(
                .init(
                    titleLocalizableKey: localized("pl_blik_text_noData"),
                    messageLocalizableKey: localized("pl_blik_text_noDataDesc"),
                    titleFontType: .bold
                )
            )
        ]
    }
    
    private func getHeaderMessage() -> String {
        return localized("pl_blik_text_listWithoutCode")
    }
    
    private func getAliasViewModel(for alias: BlikAlias) -> AliasListSettingsViewModel {
        let name: String = {
            switch alias.type {
            case .mobileDevice:
                return localized("pl_blik_text_deviceTrust", [StringPlaceholder(.value, alias.label)]).text
            case .internetBrowser:
                return localized("pl_blik_text_browserTrust", [StringPlaceholder(.value, alias.label)]).text
            case .internetShop:
                return localized("pl_blik_text_storeTrust", [StringPlaceholder(.value, alias.label)]).text
            case .contactlessHCE:
                return alias.label
            }
        }()
        return .alias(
            .init(
                aliasName: name,
                associatedModel: alias
            )
        )
    }
}
