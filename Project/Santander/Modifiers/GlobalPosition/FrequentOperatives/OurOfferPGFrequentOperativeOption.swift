//
//  OurOfferPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 3/8/21.
//

import Models
import UI
import Commons

final class OurOfferPGFrequentOperativeOption {
    let trackName: String? = "ourOffer"
    let rawValue: String = "ourOfferPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.exploreProducts.rawValue
}

extension OurOfferPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnOffer"
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
