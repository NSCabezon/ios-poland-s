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
import CoreFoundationLib

final class PLCardDetailModifier: CardDetailModifierProtocol {
    private let managersProvider: PLManagersProviderProtocol
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    var isChangeAliasEnabled: Bool = true
    var isCardHolderEnabled: Bool = true
    var prepaidCardHeaderElements: [PrepaidCardHeaderElements] = [.availableBalance]
    var debitCardHeaderElements: [DebitCardHeaderElements] = []
    var creditCardHeaderElements: [CreditCardHeaderElements] = [.limitCredit, .availableCredit, .withdrawnCredit]
    var maxAliasLength: Int {
        return 20
    }
    var regExValidatorString: CharacterSet {
        return CharacterSet(charactersIn: "1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNMąęćółńśżźĄĘĆÓŁŃŚŻŹ-.:,;/&")
    }

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.managersProvider = dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
        self.dependenciesEngine = dependenciesEngine
    }

    func formatLinkedAccount(_ linkedAccount: String?) -> String? {
        return self.dependenciesEngine.resolve(for: AccountNumberFormatterProtocol.self).accountNumberFormat(linkedAccount)
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

    func getCardDetailElements(for card: CardEntity) -> [CardDetailDataType] {
        switch card.cardType {
        case .debit:
            return [.pan, .alias, .holder, .linkedAccount, .status, .currency, .insurance]
        case .credit:
            return [.pan, .alias, .status, .holder, .currency, .creditCardAccountNumber, .interestRate, .withholdings, .previousPeriodInterest, .minimumOutstandingDue, .currentMinimumDue, .totalMinimumRepaymentAmount, .lastStatementDate, .nextStatementDate, .actualPaymentDate]
        case .prepaid:
            return [.pan, .alias, .holder, .linkedAccount, .paymentModality, .status, .currency, .creditCardAccountNumber, .insurance]
        }
    }
}
