//
//  CardTransactionsDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Fernando Sánchez García on 18/8/21.
//

import SANLegacyLibrary
import SANPLLibrary

// MARK: CardTransactionsDTOAdapter Class

final public class CardTransactionsDTOAdapter {
    
    // MARK: - Public Methods
    public func adaptPLCardTransactionsToCardTransactionsList(_ plCardTransactions: SANPLLibrary.CardTransactionListDTO) -> SANLegacyLibrary.CardTransactionsListDTO {
        var cardTransactionsListDTO = SANLegacyLibrary.CardTransactionsListDTO()
        cardTransactionsListDTO.pagination = PaginationDTO()

        if let cardTransactionsList = plCardTransactions.entries {
            cardTransactionsListDTO.transactionDTOs = self.adaptCardTransactionsListToTransactions(cardTransactionsList)
        }
        return cardTransactionsListDTO
    }
    
    public func adaptCardTransactionsListToTransactions(_ plCardTransactionsList: [SANPLLibrary.CardTransactionDTO]) -> [SANLegacyLibrary.CardTransactionDTO] {
        var cardTransactions: [SANLegacyLibrary.CardTransactionDTO] = []
        for plCardTransaction in plCardTransactionsList {
            var cardTransaction = SANLegacyLibrary.CardTransactionDTO()
            cardTransaction.identifier = plCardTransaction.sourceRef
            cardTransaction.operationDate = DateFormats.toDate(string: plCardTransaction.sourceDate ?? "", output: .YYYYMMDD)
            
            let currencyDTO = CurrencyDTO(currencyName: plCardTransaction.currencyOth ?? "", currencyType: .złoty)
            cardTransaction.amount = AmountDTO(value: plCardTransaction.amount ?? 0, currency: currencyDTO)
            cardTransaction.description = plCardTransaction.transTitle
            cardTransactions.append(cardTransaction)
        }
        return cardTransactions
    }
}

