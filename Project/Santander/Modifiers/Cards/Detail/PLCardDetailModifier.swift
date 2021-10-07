//
//  PLCardDetailModifier.swift
//  Santander
//
//  Created by Juan Sánchez Marín on 17/9/21.
//

import UI
import Foundation
import Cards
import Commons
import SANPLLibrary
import Models

final class PLCardDetailModifier: CardDetailModifierProtocol {
    private let managersProvider: PLManagersProviderProtocol
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    var isCardHolderEnabled: Bool = true
    var cardDetailElements: [CardDetailDataType] = [.pan, .alias, .holder, .linkedAccount, .paymentModality, .status, .currency, .creditCardAccountNumber, .insurance]
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
        let linkedAccountReplacing = linkedAccount.replacingOccurrences(of: " ", with: "")
        let index1 = linkedAccountReplacing.index(linkedAccountReplacing.startIndex, offsetBy: 2)
        let index2 = linkedAccountReplacing.index(linkedAccountReplacing.endIndex, offsetBy: -1)
        var formattedLinkedAccount = ""
        formattedLinkedAccount += "\(linkedAccountReplacing[..<index1]) "

        let linkedAccountTrimmed = linkedAccountReplacing[index1...index2]
        let numberOfGroups: Int = linkedAccountTrimmed.count / 4

        for iterator in 0..<numberOfGroups {
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
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }

    func isCardPANMasked(cardId: String) -> Bool {
        let cardPAN = getCardPAN(cardId: cardId)
        return cardPAN != nil ? false : true
    }

    func getCardPAN(cardId: String) -> String? {
        return managersProvider.getCardsManager().loadCardPAN(cardId: cardId)
    }
}
