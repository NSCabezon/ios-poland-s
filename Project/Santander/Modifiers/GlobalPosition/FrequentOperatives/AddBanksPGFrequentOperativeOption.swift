//
//  AddBanksPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 3/8/21.
//

import Models
import UI
import Commons

final class AddBanksPGFrequentOperativeOption {
    let trackName: String? = "addBanks"
    let rawValue: String = "addBanksPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.addBanks.rawValue
}

extension AddBanksPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnBanks"
        let titleKey: String = "frequentOperative_label_addBanks"
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
