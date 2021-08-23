//
//  PLCardTransactionsManager.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 13/8/21.
//

import Foundation

public protocol PLCardTransactionsManagerProtocol {
    func loadCardTransactions(cardId: String, pagination: TransactionsLinksDTO?, filters: String?) -> Result<CardTransactionListDTO, NetworkProviderError>?
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
    
    func loadCardTransactions(cardId: String, pagination: TransactionsLinksDTO?, filters: String?) -> Result<CardTransactionListDTO, NetworkProviderError>? {
        if let filters = filters {
            let result = dataSource.loadCardTransactions(cardId: cardId, pagination: pagination, filters: filters)
            switch result {
            case .success(let cardTransactions):
                self.dataProvider.storeCardTransactions(cardId, cardTransactions)
                return result
            case .failure:
                return .failure(NetworkProviderError.other)
            }
        } else {
            if let cardTransactions = getCardTransactions(cardId: cardId, pagination: pagination) {
                return .success(cardTransactions)
            }
            let result = dataSource.loadCardTransactions(cardId: cardId, pagination: pagination, filters: nil)
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
