//
//  DeleteAliasViewModelMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 07/09/2021.
//

import CoreFoundationLib

protocol DeleteAliasViewModelMapping {
    func map(_ alias: BlikAlias) -> DeleteAliasViewModel
}

final class DeleteAliasViewModelMapper: DeleteAliasViewModelMapping {
    func map(_ alias: BlikAlias) -> DeleteAliasViewModel {
        switch alias.type {
        case .internetBrowser:
            return DeleteAliasViewModel(
                screenTitle: localized("pl_blik_title_deleteBrowser"),
                deleteAliasMessageTitle: localized("pl_blik_text_alert_deleteBrowserTitle"),
                deleteAliasMessage: localized("pl_blik_text_alert_deleteDeviceInfo"),
                fraudTransactionMessage: localized("pl_blik_text_alert_deleteBrowserCheckbox")
            )
        case .internetShop:
            return DeleteAliasViewModel(
                screenTitle: localized("pl_blik_title_deleteStore"),
                deleteAliasMessageTitle: localized("pl_blik_text_alert_deleteStoreTitle"),
                deleteAliasMessage: localized("pl_blik_text_alert_deleteDeviceInfo"),
                fraudTransactionMessage: localized("pl_blik_text_deleteStoreCheckbox")
            )
        case .contactlessHCE, .mobileDevice:
            return DeleteAliasViewModel(
                screenTitle: localized("pl_blik_title_deleteDevice"),
                deleteAliasMessageTitle: localized("pl_blik_text_alert_deleteDeviceTitle"),
                deleteAliasMessage: localized("pl_blik_text_alert_deleteDeviceInfo"),
                fraudTransactionMessage: localized("pl_blik_text_alert_deleteDeviceCheckbox")
            )
        }
    }
}
