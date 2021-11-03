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
    private func getCachedCardTransactions(cardId: String) -> CardTransactionListDTO? {
        return dataSource.getCachedCardTransactions(cardId: cardId)
    }
    
    private func getCachedCardPagination(cardId: String) -> TransactionsLinksDTO? {
        return dataSource.getCachedCardPagination(cardId: cardId)
    }
    
    private func getCardKeyWithFilters(cardId: String, searchTerm: String? = nil, startDate: String?, endDate: String?, fromAmount: Decimal?, toAmount: Decimal?, movementType: String?, cardOperationType: String?) -> String {
        var cardKey = cardId
        
        if let searchTerm = searchTerm {
            cardKey = cardKey + "_" + searchTerm
        }
        
        if let startDate = startDate {
            cardKey = cardKey + "_" + startDate
        }
        
        if let endDate = endDate {
            cardKey = cardKey + "_" + endDate
        }
        
        if let fromAmount = fromAmount {
            cardKey = cardKey + "_" + "\(fromAmount)"
        }
        
        if let toAmount = toAmount {
            cardKey = cardKey + "_" + "\(toAmount)"
        }
        
        if let movementType = movementType {
            cardKey = cardKey + "_" + movementType
        }
        
        if let cardOperationType = cardOperationType {
            cardKey = cardKey + "_" + cardOperationType
        }
        
        return cardKey
    }
    
    func loadCardTransactions(cardId: String, pagination: TransactionsLinksDTO?, searchTerm: String? = nil, startDate: String?, endDate: String?, fromAmount: Decimal?, toAmount: Decimal?, movementType: String?, cardOperationType: String?) -> Result<CardTransactionListDTO, NetworkProviderError>? {
        
        let currentPagination = pagination
        let cardKey = getCardKeyWithFilters(cardId: cardId,
                                            searchTerm: searchTerm,
                                            startDate: startDate,
                                            endDate: endDate,
                                            fromAmount: fromAmount,
                                            toAmount: toAmount,
                                            movementType: movementType,
                                            cardOperationType: cardOperationType)
        let nextPaginationStored = getCachedCardPagination(cardId: cardKey)

        //Si no hay paginacion o si hay paginacion y es igual a la que teniamos, devolver la caché
        if nextPaginationStored?.next != currentPagination?.next {
            if let cardTransactions = getCachedCardTransactions(cardId: cardKey) {
                return .success(cardTransactions)
            }
        }
        
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
            self.dataProvider.storeCardTransactions(cardKey, cardTransactions)
            let cardPagination = TransactionsLinksDTO(next: cardTransactions.pagingLast ?? "",
                                                      previous: cardTransactions.pagingFirst ?? "")
            self.dataProvider.storeCardPagination(cardKey, cardPagination)
            return result
        case .failure:
            return .failure(NetworkProviderError.other)
        }
    }
}
