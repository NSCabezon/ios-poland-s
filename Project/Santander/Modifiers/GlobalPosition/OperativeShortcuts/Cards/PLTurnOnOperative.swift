//
//  PLTurnOnOperative.swift
//  Santander
//

import CoreFoundationLib
import CoreFoundationLib

final class PLTurnOnOperative {
    private let identifier: String = "cardsOptionButtonTurnOnPoland"
    private let localizedKey: String = "cardsOption_button_turnOn"
    private let icon: String = "icnOn"
    
    func getActionType() -> CardOperativeActionType {
        return .custom(
            OperativeActionValues(
                identifier: self.identifier,
                localizedKey: self.localizedKey,
                icon: self.icon,
                isDisabled: false))
    }
}
