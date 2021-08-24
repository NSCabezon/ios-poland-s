//
//  PLInternalTransferOperative.swift
//  Santander
//
//  Created by Rodrigo Jurado on 24/8/21.
//

import Models
import UI
import Commons

final class PLInternalTransferOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "internalTransferPoland"
    var trackName: String? = "internalTransferPoland"
    var accessibilityIdentifier: String? = "accountOptionButtonInternalTransfer"
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
