//
//  PLMobilePaymentsOperative.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 4/1/22.
//

import CoreFoundationLib
import Commons

final class PLMobilePaymentsOperative {
    private let identifier: String = "cardsOptionButtonTurnOnPoland"
    private let localizedKey: String = "cardOption_button_contactlessPayments"
    private let icon: String = "icnMobilePayments"
    
    func getActionType() -> CardOperativeActionType {
        return .custom(
            OperativeActionValues(
                identifier: self.identifier,
                localizedKey: self.localizedKey,
                icon: self.icon,
                isDisabled: false))
    }
}
