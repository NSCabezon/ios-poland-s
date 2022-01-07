//
//  PLSendMoneyFavouriteOperative.swift
//  Santander
//

import CoreFoundationLib
import UI
import Commons

final class PLSendMoneyFavouriteOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "sendFavouritePoland"
    var trackName: String? = "sendFavouritePoland"
    var accessibilityIdentifier: String? = "accountOptionButtonSendFavoritePoland"
    private let title: String = "accountOption_button_sendFavorite"
    private let icon: String = "icnSendToFavourite"

    func values() -> (title: String, imageName: String) {
        return (self.title, self.icon)
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        return .defaultButton(DefaultActionButtonViewModel(title: self.title,
                                                           imageKey: self.icon,
                                                           titleAccessibilityIdentifier: self.accessibilityIdentifier ?? "",
                                                           imageAccessibilityIdentifier: self.icon))
    }

    func getAction() -> AccountOperativeAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}
