//
//  PLSendMoneyOperative.swift
//  Santander
//

import Models
import UI
import Commons

final class PLSendMoneyOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "accountOptionButtonTransferPoland"
    var trackName: String? = "accountOptionButtonTransferPoland"
    var accessibilityIdentifier: String? = "accountOptionButtonTransfer"
    private let title: String = "accountOption_button_transfer"
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
