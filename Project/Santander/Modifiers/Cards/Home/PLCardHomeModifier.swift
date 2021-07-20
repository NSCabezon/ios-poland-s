//
//  PLCardHomeModifier.swift
//  Santander
//
//  Created by Rodrigo Jurado on 2/7/21.
//

import UI
import Cards
import Commons
import Models
import SANPLLibrary

final class PLCardHomeModifier {
    private let managersProvider: PLManagersProviderProtocol
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.managersProvider = dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
        self.dependenciesEngine = dependenciesEngine
    }
}

extension PLCardHomeModifier: CardHomeModifierProtocol {

    func isPANMasked() -> Bool {
        return true
    }

    func isCardHighlitghtedButtonsHidden() -> Bool {
        return true
    }

    func didSelectCardPendingTransactions() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }

    func showCardPAN(card: CardEntity) {
        // TODO: To be implemented
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }

    func isCardPANMasked(cardId: String) -> Bool {
        let cardPAN = getCardPAN(cardId: cardId)
        return cardPAN != nil ? false : true
    }

    func getCardPAN(cardId: String) -> String? {
        return managersProvider.getCardsManager().loadCardPAN(cardId: cardId)
    }

    func formatPAN(card: CardEntity) -> String? {
        guard let pan = card.formattedPAN else { return nil }
        return pan.inserting(separator: "  ", every: 4).replace("X", "•")
    }

    func validatePullOffersCandidates(values: CustomCardActionValues, offers: [PullOfferLocation : OfferEntity], entity: CardEntity, actionType: CardActionType, action: ((CardActionType, CardEntity) -> Void)?, candidateOffer: Bool) -> CardActionViewModel? {
        // To be implemented
        return nil
    }

    func loadOffers(dependenciesResolver: DependenciesResolver) -> [PullOfferLocation : OfferEntity] {
        // To be implemented
        return [:]
    }

    func isActivePrepaid(card: CardEntity) -> Bool {
        return card.isInactive || card.isContractBlocked
    }

    func showActivateView() -> Bool {
        return true
    }

    func getSelectedCardFromConfiguration() -> CardEntity? {
        // TODO: To be implemented
        return nil
    }

    func hideCardsHomeImageDetailsConditions() -> Bool {
        return false
    }

    func addPrepaidCardOffAction() -> Bool {
        return false
    }

}
