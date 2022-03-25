//
//  PLCardHomeModifier.swift
//  Santander
//
//  Created by Rodrigo Jurado on 2/7/21.
//

import UI
import Cards
import CoreFoundationLib
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

    func isPANAlwaysSharable() -> Bool {
        return false
    }
    
    func isInactivePrepaid(card: CardEntity) -> Bool {
        // TODO: To be implemented
        return false
    }
    
    func hideMoreOptionsButton() -> Bool {
        return false
    }
    
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
        return card.formattedPAN
    }
    
    func validatePullOffersCandidates(values: CustomCardActionValues, offers: [PullOfferLocation: OfferEntity], entity: CardEntity, actionType: CardActionType, action: ((CardActionType, CardEntity) -> Void)?, candidateOffer: Bool) -> CardActionViewModel? {
        return CardActionViewModel(entity: entity,
                                   type: actionType,
                                   action: action,
                                   isDisabled: isDisabledEntity(values: values, entity: entity),
                                   renderingMode: isDisabledEntity(values: values, entity: entity) ? .alwaysTemplate : .alwaysOriginal)
    }
    
    private func isDisabledEntity(values: CustomCardActionValues, entity: CardEntity) -> Bool {
        return values.isDisabled(entity)
    }
    
    func loadOffers(dependenciesResolver: DependenciesResolver) -> [PullOfferLocation: OfferEntity] {
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
        return true
    }
    
    func addPrepaidCardOffAction() -> Bool {
        return false
    }
}
