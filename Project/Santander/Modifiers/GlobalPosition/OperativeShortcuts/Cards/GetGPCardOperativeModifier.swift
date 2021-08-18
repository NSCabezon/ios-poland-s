//
//  GetGPCardOperativeModifier.swift
//  Santander
//

import Models
import Commons

public final class GetGPCardOperativeModifier: GetGPCardsOperativeOptionProtocol {
    var shortcutsOperativesAvailable: [CardOperativeActionType] = []

    public func getCountryCardsOperativeActionType(cards: [CardEntity]) -> [CardOperativeActionType] {
        self.shortcutsOperativesAvailable = [.offCard,
                                             .onCard,
                                             .payOff,
                                             .applePay,
                                             PLSetUpAlertsOperative().getAtionType(),
                                             PLPostponeBuyOperative().getAtionType(),
                                             .changeAlias
        ]
        return self.shortcutsOperativesAvailable
    }

    public func getAllCardsOperativeActionType() -> [CardOperativeActionType] {
        return [.offCard,
                .onCard,
                .payOff,
                .applePay,
                PLSetUpAlertsOperative().getAtionType(),
                PLPostponeBuyOperative().getAtionType(),
                .changeAlias
        ]
    }

    public func isOtherOperativeEnabled(_ option: CardOperativeActionType) -> Bool {
        return self.shortcutsOperativesAvailable.contains(option)
    }
}

private extension GetGPCardOperativeModifier {
    func checkIsEnabled(_ cards: [CardEntity]) -> Bool {
        return cards.filter { !$0.isTemporallyOff && !$0.isInactive && $0.isVisible }.isNotEmpty
    }
}