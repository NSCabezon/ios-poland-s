//
//  PLCardTransactionDetailUseCase.swift
//  Santander
//
//  Created by Hernán Villamil on 11/5/22.
//

import Foundation
import Cards
import CoreDomain
import OpenCombine

final class PLCardTransactionDetailUseCase {
    private let repository: CardRepository
    private let getCardDetailDataUseCase: GetCardDetailDataUseCase
    private let getCardTransactionConfigUseCase: GetCardTransactionConfigUseCase
    private let getContractMovementUseCase: GetContractMovementUseCase
    private let getCardTransactionDetailDataUseCase: GetCardTransactionDetailDataUseCase
    
    init(dependencies: CardTransactionDetailExternalDependenciesResolver) {
        self.repository = dependencies.resolve()
        self.getCardDetailDataUseCase = dependencies.resolve()
        self.getCardTransactionConfigUseCase = dependencies.resolve()
        self.getContractMovementUseCase = dependencies.resolve()
        self.getCardTransactionDetailDataUseCase = dependencies.resolve()
    }
}

extension PLCardTransactionDetailUseCase: CardTransactionDetailUseCase {
    func fetchCardDetailDataUseCase(card: CardRepresentable, transaction: CardTransactionRepresentable) -> AnyPublisher<CardTransactionViewItemRepresentable, Error> {
        let detaiDataPublisher = getCardDetailDataUseCase.fetchCardDetailDataUseCase(card: card,
                                                                                     transaction: transaction)
        let transactionConfigPublisher = getCardTransactionConfigUseCase.fetchConfig(card: card,
                                                                                     transaction: transaction)
        let contractmovementPublisher = getContractMovementUseCase.fetchContractMovement(card: card,
                                                                                         transaction: transaction)
        let transactionDetailPublisher = getCardTransactionDetailDataUseCase.fetchCardDetailDataUseCase(card: card,
                                                                                                        transaction: transaction)
        return Publishers.Zip4(detaiDataPublisher,
                               transactionConfigPublisher,
                               contractmovementPublisher,
                               transactionDetailPublisher)
            .map({ detail, configuration, contract, transactionDetail in
                self.getTransactionDetailItem(card: card,
                                              transaction: transaction,
                                              cardDetail: detail,
                                              configuration: configuration,
                                              contract: contract,
                                              transactionDetail: transactionDetail)
            })
            .eraseToAnyPublisher()
    }
}

private extension PLCardTransactionDetailUseCase {
    func getTransactionDetailItem(card: CardRepresentable,
                                  transaction: CardTransactionRepresentable,
                                  cardDetail: CardDetailRepresentable,
                                  configuration: CardTransactionDetailConfigRepresentable,
                                  contract: EasyPayContractTransactionRepresentable?,
                                  transactionDetail: CardTransactionDetailRepresentable) -> CardTransactionViewItemRepresentable {
        return CardTransactionDetailUseCaseOutput(card: card,
                                                 transaction: transaction,
                                                 cardDetail: cardDetail,
                                                 configuration: configuration,
                                                 contract: contract,
                                                 transactionDetail: transactionDetail)
    }
}

fileprivate struct CardTransactionDetailUseCaseOutput: CardTransactionViewItemRepresentable {
    let card: CardRepresentable
    let transaction: CardTransactionRepresentable
    var showAmountBackground: Bool = true
    var cardDetail: CardDetailRepresentable?
    var transactionDetail: CardTransactionDetailRepresentable?
    var configuration: CardTransactionDetailConfigRepresentable?
    var contract: EasyPayContractTransactionRepresentable?
    var feeData: FeeDataRepresentable?
    var easyPay: EasyPayRepresentable?
    var isFractioned: Bool = false
    var minEasyPayAmount: Double?
    var error: String?
    var offerRepresentable: OfferRepresentable?
    var shouldPresentFractionatedButton: Bool? = true
    var viewConfigurationRepresentable: [CardTransactionDetailViewConfigurationRepresentable] = []
    
    init(card: CardRepresentable,
         transaction: CardTransactionRepresentable,
         cardDetail: CardDetailRepresentable,
         configuration: CardTransactionDetailConfigRepresentable?,
         contract: EasyPayContractTransactionRepresentable?,
         transactionDetail: CardTransactionDetailRepresentable?) {
        self.card = card
        self.transaction = transaction
        self.cardDetail = cardDetail
        self.configuration = configuration
        self.contract = contract
        self.transactionDetail = transactionDetail
    }
}
