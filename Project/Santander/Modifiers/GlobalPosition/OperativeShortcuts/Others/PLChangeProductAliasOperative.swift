//
//  PLChangeProductAliasOperative.swift
//  Santander
//
//  Created by Jose Servet Font on 6/5/22.
//

import CoreFoundationLib
import UI

final class PLChangeProductAliasOperative {
    static let identifier: String = "otherOptionButtonChangeProductAliasPoland"
    private let localizedKey: String = "productOption_button_changeAlias"
    private let icon: String = "icnChangeAlias"

    func getActionType() -> OtherActionType {
        return .custom(
            OperativeActionValues(
                identifier: PLChangeProductAliasOperative.identifier,
                localizedKey: self.localizedKey,
                icon: self.icon,
                isDisabled: false))
    }

    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}
