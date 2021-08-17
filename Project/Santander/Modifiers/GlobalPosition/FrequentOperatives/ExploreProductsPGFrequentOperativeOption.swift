//
//  ExploreProductsPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 3/8/21.
//

import Models
import UI
import Commons

final class ExploreProductsPGFrequentOperativeOption {
    let trackName: String? = "exploreProducts"
    let rawValue: String = "exploreProductsPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.exploreProducts.rawValue
}

extension ExploreProductsPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnExploreProducts"
        let titleKey: String = "menu_link_contract"
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
