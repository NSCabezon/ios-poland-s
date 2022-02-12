//
//  PLCashLoanOperative.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 4/1/22.
//

import CoreFoundationLib
import UI
import Loans

final class PLCashLoanOperative {
    var rawValue: String = "CashLoanPoland"
    var accessibilityIdentifier: String?
    var trackName: String? = "CashLoanPoland"
    var title: String = "accountOption_button_cashLoan"
    var icon: String = "icnRequestMoney"
    
    func values() -> (title: String, imageName: String) {
        return (title: self.title, imageName: self.icon)
    }
        
    func getActionType() -> CoreFoundationLib.LoanActionType {
        return .custom(
            OperativeActionValues(
                identifier: self.rawValue,
                localizedKey: self.title,
                icon: self.icon,
                isDisabled: false))
    }
    
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}
