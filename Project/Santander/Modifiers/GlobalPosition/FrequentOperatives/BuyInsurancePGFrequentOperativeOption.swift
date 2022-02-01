//
//  BuyInsurancePGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 2/8/21.
//

import CoreFoundationLib
import UI
import CoreFoundationLib

final class BuyInsurancePGFrequentOperativeOption {
    let trackName: String? = "buyInsurance"
    let rawValue: String = "buyInsurancePoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.buyInsurance.rawValue
}

extension BuyInsurancePGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnExtraAportation"
        let titleKey: String = "insurancesOption_button_buyInsurance"
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
