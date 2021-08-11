//
//  PLDepositModifier.swift
//  Santander
//

import Foundation

import GlobalPosition
import UI
import Commons
import Models

final class PLDepositModifier: DepositModifier {
    override func didSelectDeposit(deposit: DepositEntity) {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}
