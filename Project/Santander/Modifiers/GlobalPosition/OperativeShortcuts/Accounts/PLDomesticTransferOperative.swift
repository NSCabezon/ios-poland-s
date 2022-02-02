//
//  PLDomesticTransferOperative.swift
//  Santander
//

import CoreFoundationLib
import UI

final class PLDomesticTransferOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "domesticTransferPoland"
    var trackName: String? = "domesticTransferPoland"
    var accessibilityIdentifier: String? = "accountOptionButtonDomesticTransfer"
    private let title: String = "accountOption_button_domesticTransfer"
    private let icon: String = "icnSendMoney"

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
