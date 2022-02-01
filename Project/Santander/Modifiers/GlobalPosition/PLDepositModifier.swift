//
//  PLDepositModifier.swift
//  Santander
//

import Foundation

import GlobalPosition
import UI
import CoreFoundationLib
import CoreFoundationLib

final class PLDepositModifier: DepositModifier {
    override func didSelectDeposit(deposit: DepositEntity) {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}
