//
//  PLCardHomeActionModifier.swift
//  Santander
//
//  Created by Rodrigo Jurado on 5/7/21.
//

import Cards
import Models
import UI
import Commons

final class PLCardHomeActionModifier: CardHomeActionModifier {
    override func getCreditCardHomeActions() -> [CardActionType] {
        return [.enable, .onCard, .offCard, .instantCash, .pin, .pdfExtract]
    }

    override func getDebitCardHomeActions() -> [CardActionType] {
        return [.enable, .onCard, .offCard, .pin, .modifyLimits, .mobileTopUp]
    }

    override func didSelectAction(_ action: CardActionType, _ entity: CardEntity) {
        switch action {
        default:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}
