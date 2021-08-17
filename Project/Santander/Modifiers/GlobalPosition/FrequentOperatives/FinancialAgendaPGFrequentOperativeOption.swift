//
//  FinancialAgendaPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 3/8/21.
//

import Models
import UI
import Commons

final class FinancialAgendaPGFrequentOperativeOption {
    let trackName: String? = "financialAgenda"
    let rawValue: String = "financialAgendaPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.financialAgenda.rawValue
}

extension FinancialAgendaPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnDiaryFinancial"
        let titleKey: String = "frequentOperative_label_financialAgenda"
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
