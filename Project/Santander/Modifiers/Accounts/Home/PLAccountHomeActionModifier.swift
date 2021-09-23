//
//  PLAccountHomeActionModifier.swift
//  Santander
//

import UI
import Models
import Account
import Commons
import Foundation

final class PLAccountHomeActionModifier: AccountHomeActionModifierProtocol {
    func didSelectAction(_ action: AccountActionType, _ entity: AccountEntity) {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
    func getActionButtonFillViewType(for accountType: AccountActionType) -> ActionButtonFillViewType? {
        return nil
    }

}
