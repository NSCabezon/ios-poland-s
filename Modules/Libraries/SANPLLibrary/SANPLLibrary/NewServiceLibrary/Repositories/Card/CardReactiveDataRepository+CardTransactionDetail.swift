//
//  CardReactiveDataRepository+CardTransactionDetail.swift
//  SANPLLibrary
//
//  Created by Hernán Villamil on 12/5/22.
//

import Foundation
import CoreDomain
import OpenCombine
import SANLegacyLibrary

extension CardReactiveDataRepository {
    public func loadCardSingleMovementLocation(card: CardRepresentable, transaction: CardTransactionRepresentable, transactionDetail: CardTransactionDetailRepresentable?) -> AnyPublisher<CardMovementLocationRepresentable, Error> {
        Fail(error: NSError(description: "unknown")).eraseToAnyPublisher()
    }
    
    public func loadFeesEasyPay(card: CardRepresentable) -> AnyPublisher<FeeDataRepresentable, Error> {
        Fail(error: NSError(description: "unknown")).eraseToAnyPublisher()
    }
    
    public func loadTransactionDetailEasyPay(card: CardRepresentable, cardDetail: CardDetailRepresentable?, transaction: CardTransactionRepresentable, transactionDetail: CardTransactionDetailRepresentable?, easyPayContract: EasyPayContractTransactionRepresentable?) -> AnyPublisher<EasyPayRepresentable, Error> {
        Fail(error: NSError(description: "unknown")).eraseToAnyPublisher()
    }
    
    public func loadContractMovement(card: CardRepresentable, date: DateFilter?) -> AnyPublisher<EasyPayContractTransactionListRepresentable, Error> {
        Fail(error: NSError(description: "unknown")).eraseToAnyPublisher()
    }
    
    public func loadCardTransactionDetail(card: CardRepresentable, transaction: CardTransactionRepresentable) -> AnyPublisher<CardTransactionDetailRepresentable, Error> {
        guard let cardDTO = card as? SANLegacyLibrary.CardDTO,
              let transactionDTO = transaction as? SANLegacyLibrary.CardTransactionDTO else {
            let error = SomeError(errorDescription: "generic_error_txt")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Future<CardTransactionDetailRepresentable, Error> { promise in
            Async(queue: .global(qos: .userInitiated)) {
                do {
                    let result = try self.getCardTransactionDetail(card: cardDTO,
                                                              transaction: transactionDTO)
                    promise(.success(result))
                }catch let error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
        
    }
    
    public func loadEasyPayFees(card: CardRepresentable, numFees: Int, balanceCode: String?, transactionDay: String?) -> AnyPublisher<FeesInfoRepresentable, Error> {
        Fail(error: NSError(description: "unknown")).eraseToAnyPublisher()
    }
}

private extension CardReactiveDataRepository {
    func getCardTransactionDetail(card: SANLegacyLibrary.CardDTO, transaction: SANLegacyLibrary.CardTransactionDTO) throws -> CardTransactionDetailRepresentable {
        let response = try cardManager.getCardTransactionDetail(cardDTO: card,
                                                                cardTransactionDTO: transaction)
        guard let result = try response.getResponseData() else {
            throw SomeError(errorDescription: try response.getErrorMessage())
        }
        return result
    }
}
