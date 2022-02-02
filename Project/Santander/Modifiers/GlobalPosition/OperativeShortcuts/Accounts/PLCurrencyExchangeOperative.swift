//
//  PLCurrencyExchangeOperative.swift
//  Santander
//

import CoreFoundationLib
import UI

final class PLCurrencyExchangeOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "currencyExchangePoland"
    var trackName: String? = "currencyExchangePoland"
    var accessibilityIdentifier: String? = "accountOptionButtonCurrencyExchange"
    private let title: String = "accountOption_button_currencyExchange"
    private let icon: String = "icnCurrencyExchange"

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
