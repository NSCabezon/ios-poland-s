//
//  CurrencyExchangePGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 2/8/21.
//

import Models
import UI
import Commons

final class CurrencyExchangePGFrequentOperativeOption {
    let trackName: String? = "currencyExchange"
    let rawValue: String = "currencyExchangePoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.currencyExchange.rawValue
}

extension CurrencyExchangePGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnCurrencyExchange"
        let titleKey: String = "accountOption_button_currencyExchange"
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
