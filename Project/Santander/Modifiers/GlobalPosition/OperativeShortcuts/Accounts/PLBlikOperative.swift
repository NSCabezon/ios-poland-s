//
//  PLBlikOperative.swift
//  Santander
//

import Models
import UI
import Commons

final class PLBlikOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "blik"
    var trackName: String? = "blik"
    var accessibilityIdentifier: String? = "ptFrequentOperativeButtonBlikPoland"
    private let title: String = "pt_frequentOperative_button_blik"
    private let icon: String = "icnBlik"

    func values() -> (title: String, imageName: String) {
        return (self.title, self.icon)
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        return .defaultButton(DefaultActionButtonViewModel(title: self.title,
                                                           imageKey: self.icon,
                                                           renderingMode: .alwaysOriginal,
                                                           titleAccessibilityIdentifier: self.accessibilityIdentifier ?? "",
                                                           imageAccessibilityIdentifier: self.icon))
    }

    func getAction() -> AccountOperativeAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}
