//
//  BlikSettingsViewModel.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 20/07/2021.
//

import CoreFoundationLib

typealias BlikSettingsMenuView = MenuView<BlikSettingsViewModel>

enum BlikSettingsViewModel: MenuViewModel, CaseIterable {
    case aliasPayment
    case phoneTransfer
    case transferLimits
    case otherSettings
    
    var image: UIImage {
        switch self {
        case .aliasPayment:
            return Images.Settings.aliasPayment
        case .phoneTransfer:
            return Images.Settings.phoneTransfer
        case .transferLimits:
            return Images.Settings.transferLimits
        case .otherSettings:
            return Images.Settings.otherSettings
        }
    }
    
    var title: String {
        switch self {
        case .aliasPayment:
            return localized("pl_blik_text_withoutCode")
        case .phoneTransfer:
            return localized("pl_blik_text_payMobile")
        case .transferLimits:
            return localized("pl_blik_text_transLimits")
        case .otherSettings:
            return localized("pl_blik_text_otherSetting")
        }
    }
    
    var description: String {
        switch self {
        case .aliasPayment:
            return localized("pl_blik_label_withoutCodeDesc")
        case .phoneTransfer:
            return localized("pl_blik_label_payMobileDesc")
        case .transferLimits:
            return localized("pl_blik_label_transLimitsDesc")
        case .otherSettings:
            return localized("pl_blik_label_otherSettingDesc")
        }
    }
}
