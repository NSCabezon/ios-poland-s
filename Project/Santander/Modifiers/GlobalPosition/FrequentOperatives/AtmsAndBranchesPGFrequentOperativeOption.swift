//
//  AtmsAndBranchesPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 12/11/21.
//

import CoreFoundationLib
import UI
import Commons

final class AtmsAndBranchesPGFrequentOperativeOption {
    let trackName: String? = "atmsAndBranches"
    let rawValue: String = "atmsAndBranchesPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.atmAndBranches.rawValue
}

extension AtmsAndBranchesPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnAtm"
        let titleKey: String = "frequentOperative_label_atm"
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
