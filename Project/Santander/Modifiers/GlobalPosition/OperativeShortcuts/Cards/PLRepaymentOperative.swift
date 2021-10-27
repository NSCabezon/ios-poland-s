//
//  PLRepaymentOperative.swift
//  Santander
//

import Models
import Commons

final class PLRepaymentOperative {
    static let identifier: String = "operateBtnPayOffOperativePoland"
    private let localizedKey: String = "cardsOption_button_cardEntry"
    private let icon: String = "icnDepositCard"

    func getActionType() -> CardOperativeActionType {
        return .custom(
            OperativeActionValues(
                identifier: PLRepaymentOperative.identifier,
                localizedKey: self.localizedKey,
                icon: self.icon,
                isDisabled: false))
    }
}
