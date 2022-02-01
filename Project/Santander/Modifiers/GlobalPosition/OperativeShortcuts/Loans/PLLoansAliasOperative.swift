//
//  PLLoansAliasOperative.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 4/1/22.
//

import CoreFoundationLib
import CoreFoundationLib
import UI
import PersonalArea

final class PLLoansAliasOperative {    
    static var rawValue: String = "LoanAliasPoland"
    var accessibilityIdentifier: String?
    var trackName: String? = "LoanAliasPoland"
    var title: String = "accountOption_button_changeLoanAlias"
    var icon: String = "icnChangeAlias"
        
    func getActionType() -> Commons.LoanActionType {
        return .custom(
            OperativeActionValues(
                identifier: PLLoansAliasOperative.rawValue,
                localizedKey: self.title,
                icon: self.icon,
                isDisabled: false))
    }
}
