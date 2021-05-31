//
//  BillTaxPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Rodrigo Jurado on 27/5/21.
//

import Models
import UI
import Commons

final class BillTaxPGFrequentOperativeOption {
    let trackName: String? = "recibos"
    let rawValue: String = "billTaxPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.btnBillTax.rawValue
}

extension BillTaxPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnBill"
        let titleKey: String = "frequentOperative_label_billTax"
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
