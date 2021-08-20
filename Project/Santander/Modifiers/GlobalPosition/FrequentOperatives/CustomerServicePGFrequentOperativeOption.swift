//
//  CustomerServicePGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 2/8/21.
//

import Models
import UI
import Commons

final class CustomerServicePGFrequentOperativeOption {
    let trackName: String? = "customerService"
    let rawValue: String = "customerServicePoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.customerService.rawValue
}

extension CustomerServicePGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnCustomerService"
        let titleKey: String = "accountOption_button_customerService"
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
