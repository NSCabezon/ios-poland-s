//
//  PLPayTaxOperative.swift
//  Santander
//

import CoreFoundationLib
import UI
import Commons

final class PLPayTaxOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "payTaxPoland"
    var trackName: String? = "payTaxPoland"
    var accessibilityIdentifier: String? = "accountOptionButtonPayTaxes"
    private let title: String = "accountOption_button_payTaxes"
    private let icon: String = "icnPayTax"

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
