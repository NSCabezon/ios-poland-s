//
//  PLTurnOffOperative.swift
//  Santander
//

import Models
import Commons

final class PLTurnOffOperative {
    private let identifier: String = "cardsOptionButtonTurnOffPoland"
    private let localizedKey: String = "cardsOption_button_turnOff"
    private let icon: String = "icnOff"

    func getActionType() -> CardOperativeActionType {
        return .custom(
            OperativeActionValues(
                identifier: self.identifier,
                localizedKey: self.localizedKey,
                icon: self.icon,
                isDisabled: false))
    }
}
