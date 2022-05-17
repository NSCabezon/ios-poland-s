//
//  PLGetCardTransactionDetailActionsUseCase.swift
//  Santander
//
//  Created by Hernán Villamil on 11/5/22.
//

import Foundation
import Cards
import CoreDomain
import OpenCombine
import CoreFoundationLib

final class PLGetCardTransactionDetailActionsUseCase {
    private let offerIntepreter: PullOffersInterpreter
    
    init(dependencies: CardTransactionDetailExternalDependenciesResolver) {
        self.offerIntepreter = dependencies.resolve()
    }
}

extension PLGetCardTransactionDetailActionsUseCase: GetCardTransactionDetailActionsUseCase {
    func fetchCardTransactionDetailActions(item: CardTransactionViewItemRepresentable) -> AnyPublisher<[CardActions], Never> {
        let actions: [CardActions] = getActions(item: item)
        return Just(actions)
            .eraseToAnyPublisher()
    }
}

private extension PLGetCardTransactionDetailActionsUseCase {
    func getActions(item: CardTransactionViewItemRepresentable) -> [CardActions] {
        if item.card.isPrepaidCard {
            return getPrepaidCardActions(item: item)
        } else {
            return getOtherCardActions(item: item)
        }
    }
    
    func getPrepaidCardActions(item: CardTransactionViewItemRepresentable) -> [CardActions] {
        let builder = CardTransactionActionBuilder(card: item.card, action: nil)
        let subject = builder.stateSubject
        subject.send(.addPrepaid(isActionDisabled(item.card)))
        subject.send(.addShare(isActionDisabled(item.card)))
        return builder.build()
    }
    
    func getOtherCardActions(item: CardTransactionViewItemRepresentable) -> [CardActions] {
        let builder = CardTransactionActionBuilder(card: item.card, action: nil)
        let subject = builder.stateSubject
        if isInactive(item.card) {
            subject.send(.addEnable)
        }
        if isDisabled(item.card) {
            subject.send(.addOn)
        }
        if !isDisabled(item.card) {
            subject.send(.addOff)
        }
        if item.transaction.receiptId != nil {
            subject.send(.addPDFDetail)
        }
        subject.send(.addShare(isActionDisabled(item.card)))
        return builder.build()
    }
}

private extension PLGetCardTransactionDetailActionsUseCase {
    func isInactive(_ card: CardRepresentable) -> Bool {
        card.isContractInactive || card.inactive == true
    }
    
    func isDisabled(_ card: CardRepresentable) -> Bool {
        card.isContractBlocked || card.isTemporallyOff == true
    }
    
    func isActionDisabled(_ card: CardRepresentable) -> Bool {
        isInactive(card) || isDisabled(card)
    }
}
