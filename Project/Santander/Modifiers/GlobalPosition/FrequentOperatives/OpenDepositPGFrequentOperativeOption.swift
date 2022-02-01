//
//  OpenDepositPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 2/8/21.
//

import CoreFoundationLib
import UI
import CoreFoundationLib

final class OpenDepositPGFrequentOperativeOption {
    let trackName: String? = "openDeposit"
    let rawValue: String = "openDepositPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.openDeposit.rawValue
}

extension OpenDepositPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnOpenDeposit"
        let titleKey: String = "accountOption_button_openDeposit"
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
