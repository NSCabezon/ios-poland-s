//
//  PLCardTransactionsManager.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 13/8/21.
//

import Foundation

public protocol PLCardTransactionsManagerProtocol {
    func loadCardTransactions(cardId: String, pagination: TransactionsLinksDTO?, searchTerm: String?, startDate: String?, endDate: String?, fromAmount: Decimal?, toAmount: Decimal?, movementType: String?, cardOperationType: String?) -> Result<CardTransactionListDTO, NetworkProviderError>?
}

final class PLCardTransactionsManager {
    private let dataProvider: BSANDataProvider
    private let dataSource: CardTransactionsDataSource
    
    init(dataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.dataProvider = dataProvider
        self.dataSource = CardTransactionsDataSource(networkProvider: networkProvider, dataProvider: dataProvider)
    }
}

extension PLCardTransactionsManager: PLCardTransactionsManagerProtocol {
    func getCardTransactions(cardId: String, pagination: TransactionsLinksDTO?) -> CardTransactionListDTO? {
        return dataSource.getCardTransactions(cardId: cardId, pagination: pagination)
    }
    
    func loadCardTransactions(cardId: String, pagination: TransactionsLinksDTO?, searchTerm: String? = nil, startDate: String?, endDate: String?, fromAmount: Decimal?, toAmount: Decimal?, movementType: String?, cardOperationType: String?) -> Result<CardTransactionListDTO, NetworkProviderError>? {
        if searchTerm != nil || (startDate != nil && endDate != nil) || (fromAmount != nil && toAmount != nil) || movementType !=  nil || cardOperationType != nil {
            let result = dataSource.loadCardTransactions(cardId: cardId,
                                                         pagination: pagination,
                                                         searchTerm: searchTerm,
                                                         startDate: startDate,
                                                         endDate: endDate,
                                                         fromAmount: fromAmount,
                                                         toAmount: toAmount,
                                                         movementType: movementType,
                                                         cardOperationType: cardOperationType)
            switch result {
            case .success(let cardTransactions):
                self.dataProvider.storeCardTransactions(cardId, cardTransactions)
                return result
            case .failure:
                return .failure(NetworkProviderError.other)
            }
        } else {
            let result = dataSource.loadCardTransactions(cardId: cardId, pagination: pagination)
            switch result {
            case .success(let cardTransactions):
                self.dataProvider.storeCardTransactions(cardId, cardTransactions)
                return result
            case .failure:
                return .failure(NetworkProviderError.other)
            }
        }
    }
}
