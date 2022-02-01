//
//  PLApplePayOperative.swift
//  Santander
//
//  Created by Rodrigo Jurado on 23/8/21.
//

import CoreFoundationLib
import CoreFoundationLib

final class PLApplePayOperative {
    private let identifier: String = "operateBtnApplePayOperativePoland"
    private let localizedKey: String = "addCard_button_AddToApplePay"
    private let icon: String = "icnApplePay"

    func getActionType() -> CardOperativeActionType {
        return .custom(
            OperativeActionValues(
                identifier: self.identifier,
                localizedKey: self.localizedKey,
                icon: self.icon,
                isDisabled: false,
                renderingMode: .alwaysOriginal))
    }
}
