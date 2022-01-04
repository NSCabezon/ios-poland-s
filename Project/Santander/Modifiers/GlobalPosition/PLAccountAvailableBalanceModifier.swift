//
//  PLAccountAvailableBalanceModifier.swift
//  Santander
//
//  Created by Francisco Perez Martinez on 29/11/21.
//

import GlobalPosition

final class PLAccountAvailableBalanceModifier: AccountAvailableBalanceDelegate {
    func isEnabled() -> Bool {
        return true
    }
}
