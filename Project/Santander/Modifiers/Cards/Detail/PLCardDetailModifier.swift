//
//  PLCardDetailModifier.swift
//  Santander
//
//  Created by Juan Sánchez Marín on 17/9/21.
//

import Foundation
import Cards
import Commons
import SANPLLibrary
import Models

final class PLCardDetailModifier: CardDetailModifierProtocol {
    private let managersProvider: PLManagersProviderProtocol
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    var isCardHolderEnabled: Bool = true
    var cardDetailElements: [CardDetailDataType] = [.pan, .alias, .holder, .linkedAccount, .paymentModality, .situation, .status, .currency, .creditCardAccountNumber]
    var prepaidCardHeaderElements: [PrepaidCardHeaderElements] = [.availableBalance]
    var debitCardHeaderElements: [DebitCardHeaderElements] = []
    var creditCardHeaderElements: [CreditCardHeaderElements] = [.limitCredit, .availableCredit, .withdrawnCredit]

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.managersProvider = dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
        self.dependenciesEngine = dependenciesEngine
    }

    func formatLinkedAccount(_ linkedAccount: String?) -> String? {
        guard let linkedAccount = linkedAccount else {
            return nil
        }
        let linkedAccountTrimmed = linkedAccount.replacingOccurrences(of: " ", with: "")
        let numberOfGroups: Int = linkedAccountTrimmed.count / 4
        var formattedLinkedAccount = ""
        for iterator in 1..<numberOfGroups {
            let firstIndex = linkedAccountTrimmed.index(linkedAccountTrimmed.startIndex, offsetBy: 4*iterator)
            let secondIndex = linkedAccountTrimmed.index(linkedAccountTrimmed.startIndex, offsetBy: 4*(iterator+1) - 1)
            formattedLinkedAccount += "\(linkedAccountTrimmed[firstIndex...secondIndex]) "
        }
        if linkedAccountTrimmed.count > 4*numberOfGroups {
            formattedLinkedAccount += "\(linkedAccountTrimmed.suffix(linkedAccountTrimmed.count - 4*numberOfGroups))"
        }
        return formattedLinkedAccount
    }

    func showCardPAN(card: CardEntity) {
        
    }

    func isCardPANMasked(cardId: String) -> Bool {
        let cardPAN = getCardPAN(cardId: cardId)
        return cardPAN != nil ? false : true
    }

    func getCardPAN(cardId: String) -> String? {
        return managersProvider.getCardsManager().loadCardPAN(cardId: cardId)
    }
}
