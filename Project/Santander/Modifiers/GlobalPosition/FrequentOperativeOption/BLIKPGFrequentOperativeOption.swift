//
//  BLIKPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Rodrigo Jurado on 26/5/21.
//

import Models
import UI
import Commons

final class BLIKPGFrequentOperativeOption {
    let trackName: String? = "blik_pl"
    let rawValue: String = "blikPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.btnBlik.rawValue
}

extension BLIKPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnBlik"
        let titleKey: String = "pt_frequentOperative_button_blik"
        return .defaultButton(
            DefaultActionButtonViewModel(
                title: titleKey,
                imageKey: imageKey,
                renderingMode: .alwaysOriginal,
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
