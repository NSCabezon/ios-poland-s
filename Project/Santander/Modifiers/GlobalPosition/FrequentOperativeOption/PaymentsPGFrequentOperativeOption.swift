//
//  PaymentsPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Rodrigo Jurado on 27/5/21.
//

import CoreFoundationLib
import UI
import Commons

final class PaymentsPGFrequentOperativeOption {
    let trackName: String? = "enviar_dinero"
    let rawValue: String = "paymentsPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.btnPayments.rawValue
}

extension PaymentsPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnSendMoney"
        let titleKey: String = "menu_link_onePayTransfer"
        return .defaultButton(
            DefaultActionButtonViewModel(
                title: titleKey,
                imageKey: imageKey,
                titleAccessibilityIdentifier: titleKey,
                imageAccessibilityIdentifier: imageKey
            )
        )
    }

    func getEnabled() -> PGFrequentOperativeOptionEnabled {
        return .custom(enabled: { return true })
    }

    func getLocation() -> String? {
        return nil
    }
}
