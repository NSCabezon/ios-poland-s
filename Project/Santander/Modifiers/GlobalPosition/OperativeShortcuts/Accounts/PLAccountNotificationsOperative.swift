//
//  PLAccountNotificationsOperative.swift
//  Santander
//

import CoreFoundationLib
import UI

final class PLAccountNotificationsOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "accountNotificationsPoland"
    var trackName: String? = "accountNotificationsPoland"
    var accessibilityIdentifier: String? = "accountOptionButtonSettingAlerts"
    private let title: String = "accountOption_button_settingAlerts"
    private let icon: String = "icnAlertConfig"

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
