//
//  PLFundModifier.swift
//  Santander
//

import GlobalPosition
import UI
import Commons
import Models

final class PLFundModifier: FundModifier {
    override func didSelectFund(fund: FundEntity) {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}
