//
//  PLSetUpAlertsOperative.swift
//  Santander
//

import Models
import Commons

final class PLSetUpAlertsOperative {
    private let identifier: String = "cardsOptionButtonSettingAlertsPoland"
    private let localizedKey: String = "cardsOption_button_settingAlerts"
    private let icon: String = "icnAlertConfig"

    func getAtionType() -> CardOperativeActionType {
        return .custom(
            OperativeActionValues(
                identifier: self.identifier,
                localizedKey: self.localizedKey,
                icon: self.icon,
                isDisabled: false))
    }
}
