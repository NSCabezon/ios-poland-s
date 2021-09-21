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

            let currencyType: CurrencyType
            if let currencyOth = plCardTransaction.currencyOth {
                switch currencyOth {
                case "EUR":
                    currencyType = .eur
                case "USD":
                    currencyType = .dollar
                case "GBP":
                    currencyType = .pound
                case "CHF":
                    currencyType = .swissFranc
                case "PLN":
                    currencyType = .złoty
                default:
                    currencyType = .other
                }
            } else {
                currencyType = .złoty
            }
            
            let currencyDTO = CurrencyDTO(currencyName: plCardTransaction.currencyOth ?? "", currencyType: currencyType)
            cardTransaction.amount = AmountDTO(value: plCardTransaction.amount ?? 0, currency: currencyDTO)
            cardTransaction.description = plCardTransaction.transTitle
            cardTransactions.append(cardTransaction)
        }
        return cardTransactions
    }
}

