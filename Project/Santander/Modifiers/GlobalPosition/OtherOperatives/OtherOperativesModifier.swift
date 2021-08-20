//
//  OtherOperativesModifier.swift
//  Santander
//

import GlobalPosition
import Models
import Commons
import UI

final class OtherOperativesModifier: OtherOperativesModifierProtocol {
    func isOtherOperativeEnabled(_ option: PGFrequentOperativeOption) -> Bool {
        return true
    }

    func performAction(_ values: OperativeActionValues) {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}
