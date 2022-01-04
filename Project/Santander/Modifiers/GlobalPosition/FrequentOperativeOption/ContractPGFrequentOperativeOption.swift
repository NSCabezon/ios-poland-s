//
//  ContractPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Rodrigo Jurado on 27/5/21.
//

import CoreFoundationLib
import UI
import Commons

final class ContractPGFrequentOperativeOption {
    let trackName: String? = "contratar"
    let rawValue: String = "contractPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.btnContract.rawValue
}

extension ContractPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnExploreProducts"
        let titleKey: String = "frequentOperative_button_contract"
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
