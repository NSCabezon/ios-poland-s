//
//  BlikSettingsViewModel.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 20/07/2021.
//

typealias BlikSettingsMenuView = MenuView<BlikSettingsViewModel>

enum BlikSettingsViewModel: MenuViewModel, CaseIterable {
    case codelessPayment
    case phoneTransfer
    case transferLimits
    case otherSettings
    
    var image: UIImage {
        switch self {
        case .codelessPayment:
            return Images.Settings.codelessPayment
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
        case .codelessPayment:
            return "#Zakupy bez kodu"
        case .phoneTransfer:
            return "#Przelew na telefon BLIK"
        case .transferLimits:
            return "#Limity Transakcji BLIK"
        case .otherSettings:
            return "#Pozostałe ustawienia BLIK"
        }
    }
    
    var description: String {
        switch self {
        case .codelessPayment:
            return "#Płać  szybciej i wygodniej w internecie."
        case .phoneTransfer:
            return "#Pieniądze  błyskawicznie na koncie odbiorcy."
        case .transferLimits:
            return "#Dzienne limity transakcji i czeków."
        case .otherSettings:
            return "#Widoczność szczegółów transakcji."
        }
    }
}
