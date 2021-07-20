//
//  PLAccountHomeActionModifier.swift
//  Santander
//

import UI
import Models
import Account
import Commons
import Foundation

final class PLAccountHomeActionModifier: AccountHomeActionModifier {
    private let blik: AccountActionType = .custome(identifier: "blik",
                                                   accesibilityIdentifier: "blik",
                                                   trackName: "blik",
                                                   localizedKey: "pt_frequentOperative_button_blik",
                                                   icon: "icnBlik"
    )

    private let savingsGoals: AccountActionType = .custome(identifier: "savingsGoals",
                                                           accesibilityIdentifier: "savingsGoals",
                                                           trackName: "savingsGoals",
                                                           localizedKey: "accountOption_button_savingGoals",
                                                           icon: "icnSavingGoals"
    )

    override func getHomeActions() -> [AccountActionType] {
        return [.transfer, self.blik, .accountDetail, self.savingsGoals]
    }

    override func didSelectAction(_ action: AccountActionType, _ entity: AccountEntity) {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}
