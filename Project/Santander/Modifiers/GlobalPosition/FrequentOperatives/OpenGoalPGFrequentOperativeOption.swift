//
//  OpenGoalPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 2/8/21.
//

import CoreFoundationLib
import UI
import CoreFoundationLib

final class OpenGoalPGFrequentOperativeOption {
    let trackName: String? = "openGoal"
    let rawValue: String = "openGoalPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.openGoal.rawValue
}

extension OpenGoalPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnSavingGoals"
        let titleKey: String = "frequentOperative_button_openGoal"
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
