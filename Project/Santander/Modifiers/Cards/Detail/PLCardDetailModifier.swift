//
//  PLCardDetailModifier.swift
//  Santander
//
//  Created by Juan Sánchez Marín on 17/9/21.
//

import UI
import Foundation
import Cards
import CoreFoundationLib
import SANPLLibrary

final class PLCardDetailModifier: CardDetailModifierProtocol {
    private let managersProvider: PLManagersProviderProtocol
    private let legacyDependenciesResolver: DependenciesResolver
    var isChangeAliasEnabled: Bool = true
    var isCardHolderEnabled: Bool = true
    var prepaidCardHeaderElements: [PrepaidCardHeaderElements] = [.availableBalance]
    var debitCardHeaderElements: [DebitCardHeaderElements] = []
    var creditCardHeaderElements: [CreditCardHeaderElements] = [.limitCredit, .availableCredit, .withdrawnCredit]
    var maxAliasLength: Int {
        return 20
    }
    var regExValidatorString: CharacterSet {
        return CharacterSet(charactersIn: "1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNMąęćółńśżźĄĘĆÓŁŃŚŻŹ-.:,;/& ")
    }

    init(legacyDependenciesResolver: DependenciesResolver) {
        self.managersProvider = legacyDependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.legacyDependenciesResolver = legacyDependenciesResolver
    }

    func formatLinkedAccount(_ linkedAccount: String?) -> String? {
        return self.legacyDependenciesResolver.resolve(for: AccountNumberFormatterProtocol.self).accountNumberFormat(linkedAccount)
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
