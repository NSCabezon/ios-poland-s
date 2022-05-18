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
    public init() { }
    
    // MARK: - Public Methods
    public func adaptPLCardTransactionsToCardTransactionsList(_ plCardTransactions: SANPLLibrary.CardTransactionListDTO) -> SANLegacyLibrary.CardTransactionsListDTO {
        var cardTransactionsListDTO = SANLegacyLibrary.CardTransactionsListDTO()
        cardTransactionsListDTO.pagination = PaginationDTO()
        cardTransactionsListDTO.pagination.repositionXML = plCardTransactions.pagingLast ?? ""
        cardTransactionsListDTO.pagination.accountAmountXML = plCardTransactions.pagingFirst ?? ""
        cardTransactionsListDTO.pagination.endList = true
        if let _ = plCardTransactions.pagingLast {
            cardTransactionsListDTO.pagination.endList = false
        }
        
        if let cardTransactionsList = plCardTransactions.entries {
            cardTransactionsListDTO.transactionDTOs = self.adaptCardTransactionsListToTransactions(cardTransactionsList)
        }
        return cardTransactionsListDTO
    }
    
    public func adaptPLCardTransactionsToCardPendingTransactionsList(_ plCardTransactions: SANPLLibrary.CardTransactionListDTO) -> SANLegacyLibrary.CardPendingTransactionsListDTO {
        var cardPendingTransactionsListDTO = SANLegacyLibrary.CardPendingTransactionsListDTO()
        cardPendingTransactionsListDTO.pagination = adaptPendingCardTransactionsToPaginationDTO(plCardTransactions)
        
        if let cardTransactionsList = plCardTransactions.entries {
            cardPendingTransactionsListDTO.cardPendingTransactionDTOS = self.adaptCardTransactionsListToPendingTransactions(cardTransactionsList)
        }
        return cardPendingTransactionsListDTO
    }
    
    private func adaptPendingCardTransactionsToPaginationDTO(_ plCardTransactions: SANPLLibrary.CardTransactionListDTO) -> SANLegacyLibrary.PaginationDTO {
        
        var paginationDTO = SANLegacyLibrary.PaginationDTO()
        paginationDTO.endList = true
        if let pagingLast = plCardTransactions.pagingLast, pagingLast != "" {
            paginationDTO.repositionXML = pagingLast
            paginationDTO.endList = false
        }
        if let pagingFirst = plCardTransactions.pagingFirst {
            paginationDTO.accountAmountXML = pagingFirst
        }
        return paginationDTO
    }
    
    private func adaptCardTransactionsListToTransactions(_ plCardTransactionsList: [SANPLLibrary.CardTransactionDTO]) -> [SANLegacyLibrary.CardTransactionDTO] {
        var cardTransactions: [SANLegacyLibrary.CardTransactionDTO] = []
        for plCardTransaction in plCardTransactionsList {
            var cardTransaction = SANLegacyLibrary.CardTransactionDTO()
            cardTransaction.identifier = plCardTransaction.sourceRef
            cardTransaction.operationDate = DateFormats.toDate(string: plCardTransaction.sourceDate ?? "", output: .YYYYMMDD)

            let currencyType: CurrencyType
            if let currencyOth = plCardTransaction.currency {
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
                    currencyType = .other(currencyOth)
                }
            } else {
                currencyType = .złoty
            }
            
            let currencyDTO = CurrencyDTO(currencyName: plCardTransaction.currency ?? "", currencyType: currencyType)
            var amount = AmountDTO(value: plCardTransaction.amount ?? 0, currency: currencyDTO)
            if plCardTransaction.debitFlag?.lowercased() == "debit" {
                amount.value?.negate()
            }
            cardTransaction.amount = amount
            cardTransaction.description = plCardTransaction.transTitle
            
            cardTransaction.state = .getState(plCardTransaction.state)
            cardTransaction.postedDate = plCardTransaction.postedDate
            cardTransaction.recipient = plCardTransaction.acceptor
            cardTransaction.cardAccountNumber = plCardTransaction.accountNumber
            cardTransaction.operationType = plCardTransaction.debitFlag
            cardTransaction.sourceDate = plCardTransaction.sourceDate
            cardTransaction.receiptId = plCardTransaction.receiptId
            
            cardTransactions.append(cardTransaction)
            
            
        }
        return cardTransactions
    }
    
    private func adaptCardTransactionsListToPendingTransactions(_ plCardTransactionsList: [SANPLLibrary.CardTransactionDTO]) -> [SANLegacyLibrary.CardPendingTransactionDTO] {
        var pendingCardTransactions: [SANLegacyLibrary.CardPendingTransactionDTO] = []
        
        for plCardTransaction in plCardTransactionsList {
            var pendingCardTransaction = SANLegacyLibrary.CardPendingTransactionDTO()
            pendingCardTransaction.cardNumber = plCardTransaction.sourceRef
            pendingCardTransaction.annotationDate = DateFormats.toDate(string: plCardTransaction.sourceDate ?? "", output: .YYYYMMDD)

            let currencyType: CurrencyType
            if let currencyOth = plCardTransaction.currency {
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
                    currencyType = .other(currencyOth)
                }
            } else {
                currencyType = .złoty
            }
            
            let currencyDTO = CurrencyDTO(currencyName: plCardTransaction.currency ?? "", currencyType: currencyType)
            pendingCardTransaction.amount = AmountDTO(value: plCardTransaction.amount ?? 0, currency: currencyDTO)
            pendingCardTransaction.description = plCardTransaction.transTitle
            pendingCardTransactions.append(pendingCardTransaction)
        }
        
        return pendingCardTransactions
    }
}
