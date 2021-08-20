//
//  AccountStatementPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 2/8/21.
//

import Models
import UI
import Commons

final class AccountStatementPGFrequentOperativeOption {
    let trackName: String? = "accountStatement"
    let rawValue: String = "accountStatementPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.accountStatement.rawValue
}

extension AccountStatementPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnAccountStatements"
        let titleKey: String = "accountOption_button_statements"
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
