//
//  PLFundModifier.swift
//  Santander
//

import GlobalPosition
import UI
import CoreFoundationLib

final class PLFundModifier: FundModifier {
    override func didSelectFund(fund: FundEntity) {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}
