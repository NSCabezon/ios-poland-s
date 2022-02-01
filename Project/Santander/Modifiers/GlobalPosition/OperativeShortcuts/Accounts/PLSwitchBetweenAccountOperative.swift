//
//  PLSwitchBetweenAccountOperative.swift
//  Santander
//

import CoreFoundationLib
import UI
import CoreFoundationLib

final class PLSwitchBetweenAccountOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "switchBetweenAccountPoland"
    var trackName: String? = "switchBetweenAccountPoland"
    var accessibilityIdentifier: String? = "accountOptionButtonTransferAccount"
    private let title: String = "accountOption_button_transferAccount"
    private let icon: String = "icnTransferAccounts"

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
