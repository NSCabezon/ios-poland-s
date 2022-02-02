//
//  PLBuyInsuranceOperative.swift
//  Santander
//

import CoreFoundationLib
import UI

final class PLBuyInsuranceOperative {
    private let identifier: String = "insurancesOptionButtonBuyInsurancePoland"
    private let localizedKey: String = "insurancesOption_button_buyInsurance"
    private let icon: String = "icnExtraAportation"

    func getActionType() -> InsuranceProtectionActionType {
        return .custom(
            OperativeActionValues(
                identifier: self.identifier,
                localizedKey: self.localizedKey,
                icon: self.icon,
                isDisabled: false))
    }

    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}
