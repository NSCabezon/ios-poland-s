//
//  PLGetCardDetailConfigurationUseCase.swift
//  Santander
//
//  Created by Gloria Cano López on 7/3/22.
//

import CoreFoundationLib
import Cards
import CoreDomain
import Foundation
import OpenCombine
import SANPLLibrary

struct PLGetCardDetailConfigurationUseCase {
    private let managersProvider: PLManagersProviderProtocol
    private let dependenciesEngine: DependenciesResolver
    
    init(dependenciesEngine: DependenciesResolver) {
        self.dependenciesEngine = dependenciesEngine
        self.managersProvider = dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
    }
}

extension PLGetCardDetailConfigurationUseCase: GetCardDetailConfigurationUseCase {
    public func fetchCardDetailConfiguration(card: CardRepresentable, cardDetail: CoreDomain.CardDetailRepresentable) -> AnyPublisher<CardDetailConfiguration, Never> {
        return Just(getCardDetailConfiguration(card: card, cardDetail: cardDetail))
            .eraseToAnyPublisher()
    }
}

private extension PLGetCardDetailConfigurationUseCase {
    
    func getCardDetailConfiguration(card: CardRepresentable, cardDetail: CoreDomain.CardDetailRepresentable) ->
    CardDetailConfiguration {
        let cardDetailConfiguration = CardDetailConfiguration(card: card, cardDetail: cardDetail)
        let alias = CardAliasConfiguration(isChangeAliasEnabled: true, regExValidatorString: regExValidatorString)
        cardDetailConfiguration.formatLinkedAccount = formatLinkedAccount(cardDetail.linkedAccount)
        cardDetailConfiguration.formatLinkeWithCreditCardAccountNumber = formatLinkedAccount(cardDetail.creditCardAccountNumber)
        cardDetailConfiguration.cardAliasConfiguration = alias
        cardDetailConfiguration.isCardHolderEnabled = true
        cardDetailConfiguration.cardPAN = formatPAN(card: card)
        cardDetailConfiguration.isCardPANMasked = isCardPANMasked(cardId: card.contractRepresentable?.contractNumber)
        cardDetailConfiguration.creditCardHeaderElements = [.limitCredit, .availableCredit, .withdrawnCredit]
        cardDetailConfiguration.debitCardHeaderElements = []
        cardDetailConfiguration.prepaidCardHeaderElements = [.availableBalance]
        cardDetailConfiguration.cardDetailElements = getCardDetailElements(for: card)
        if let cardID = card.contractRepresentable?.contractNumber, isCardPANMasked(cardId: cardID), let cardPAN =  getCardPAN(cardId: cardID) {
            cardDetailConfiguration.card.PAN = cardPAN
        }
        
        return cardDetailConfiguration
    }
    var regExValidatorString: CharacterSet {
        return CharacterSet(charactersIn: "1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNMąęćółńśżźĄĘĆÓŁŃŚŻŹ-.:,;/& ")
    }
    
    func isCardPANMasked(cardId: String?) -> Bool {
        guard let identifier = cardId else { return false }
        let cardPAN = getCardPAN(cardId: identifier)
        return cardPAN != nil ? false : true
    }
    
    func getCardPAN(cardId: String) -> String? {
        return managersProvider.getCardsManager().loadCardPAN(cardId: cardId)
    }
    
    func formatPAN(card: CardRepresentable) -> String? {
        return card.formattedPAN
    }
    
    func formatLinkedAccount(_ linkedAccount: String?) -> String? {
        return self.dependenciesEngine.resolve(for: AccountNumberFormatterProtocol.self).accountNumberFormat(linkedAccount)
    }
    
    func getCardDetailElements(for card: CardRepresentable) -> [CardDetailDataType] {
        if card.isDebitCard {
            return [.pan, .alias, .holder, .linkedAccount, .status, .currency, .insurance]
        } else if card.isCreditCard {
            return [.pan, .alias, .status, .holder, .currency, .creditCardAccountNumber, .interestRate, .withholdings, .previousPeriodInterest, .minimumOutstandingDue, .currentMinimumDue, .totalMinimumRepaymentAmount, .lastStatementDate, .nextStatementDate, .actualPaymentDate]
        } else {
            return [.pan, .alias, .holder, .linkedAccount, .paymentModality, .status, .currency, .creditCardAccountNumber, .insurance]
        }
    }
}
