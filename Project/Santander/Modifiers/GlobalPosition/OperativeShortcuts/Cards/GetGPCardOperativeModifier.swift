//
//  GetGPCardOperativeModifier.swift
//  Santander
//

import CoreFoundationLib

public final class GetGPCardOperativeModifier: GetGPCardsOperativeOptionProtocol {
    var shortcutsOperativesAvailable: [CardOperativeActionType] = []

    public func getCountryCardsOperativeActionType(cards: [CardEntity]) -> [CardOperativeActionType] {
        shortcutsOperativesAvailable = []
        if checkOffCardIsEnabled(cards) {
            self.shortcutsOperativesAvailable.append(.offCard)
        }
        if checkOnCardIsEnabled(cards) {
            self.shortcutsOperativesAvailable.append(.onCard)
        }
        if cards.isNotEmpty {
            self.shortcutsOperativesAvailable.append(PLRepaymentOperative().getActionType())
        }
        self.shortcutsOperativesAvailable.append(contentsOf: [
                                                              PLPostponeBuyOperative().getAtionType()
        ])
        return self.shortcutsOperativesAvailable
    }

    public func getAllCardsOperativeActionType() -> [CardOperativeActionType] {
        var actionTypes: [CardOperativeActionType] = []
        if isOtherOperativeEnabled(.offCard) {
            actionTypes.append(.offCard)
        }
        if isOtherOperativeEnabled(.onCard) {
            actionTypes.append(.onCard)
        }
        actionTypes.append(contentsOf: [PLRepaymentOperative().getActionType(),
                                        PLPostponeBuyOperative().getAtionType()
                                       ])
        return actionTypes
    }

    public func isOtherOperativeEnabled(_ option: CardOperativeActionType) -> Bool {
        return self.shortcutsOperativesAvailable.contains(option)
    }
}

private extension GetGPCardOperativeModifier {
    func checkIsEnabled(_ cards: [CardEntity]) -> Bool {
        return cards.filter { !$0.isTemporallyOff && !$0.isInactive && $0.isVisible }.isNotEmpty
    }

    func checkOffCardIsEnabled(_ cards: [CardEntity]) -> Bool {
        return cards.filter { $0.isReadyForOff }.isNotEmpty
    }

    func checkOnCardIsEnabled(_ cards: [CardEntity]) -> Bool {
        return cards.filter { $0.isReadyForOn }.isNotEmpty
    }
}
