//
//  PLMakeDonationOperative.swift
//  Santander
//

import CoreFoundationLib
import UI
import Commons

final class PLMakeDonationOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "makeDonationPoland"
    var trackName: String? = "makeDonationPoland"
    var accessibilityIdentifier: String? = "accountOption_button_donations"
    private let title: String = "accountOption_button_donations"
    private let icon: String = "icnDonations"

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
