//
//  PLPostponeBuyOperative.swift
//  Santander
//

import CoreFoundationLib
import CoreFoundationLib

final class PLPostponeBuyOperative {
    private let identifier: String = "operateBtnPostponeBuyPoland"
    private let localizedKey: String = "cardsOption_button_postponeBuy"
    private let icon: String = "icnRatio"

    func getAtionType() -> CardOperativeActionType {
        return .custom(
            OperativeActionValues(
                identifier: self.identifier,
                localizedKey: self.localizedKey,
                icon: self.icon,
                isDisabled: false))
    }
}
