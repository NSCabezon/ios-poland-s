//
//  PLGetFilteredCardsTransactionsUseCase.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 9/2/22.
//

import SANLegacyLibrary
import CoreFoundationLib
import Commons
import Cards
import SANPLLibrary
import PLLegacyAdapter

final class PLGetFilteredCardTransactionsUseCase: UseCase<GetFilteredCardTransactionsUseCaseInput, GetFilteredCardTransactionsUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let bsanDataProvider: BSANDataProvider
    
    init(dependenciesResolver: DependenciesResolver, bsanDataProvider: BSANDataProvider) {
        self.dependenciesResolver = dependenciesResolver
        self.bsanDataProvider = bsanDataProvider
    }
    
    override func executeUseCase(requestValues: GetFilteredCardTransactionsUseCaseInput) throws -> UseCaseResponse<GetFilteredCardTransactionsUseCaseOkOutput, StringErrorOutput> {
        
        let provider = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getCardTransactionsManager()
        let cardEntity = requestValues.card
        guard let cardId = cardEntity.dto.contract?.contractNumber else { return .error(StringErrorOutput(localized("generic_alert_errorCard")))
        }
        let filters = requestValues.filters
        let dateInterval = filters?.getDateRange()
        let fromDate = dateInterval?.fromDate.toString(format: "yyyy-MM-dd")
        let toDate = dateInterval?.toDate.toString(format: "yyyy-MM-dd")
        let movementType = adaptMovementType(filters?.getMovementType())
        let cardPagination = TransactionsLinksDTO(next: requestValues.pagination?.dto?.repositionXML, previous: requestValues.pagination?.dto?.accountAmountXML)

        let result = try provider.loadCardTransactions(cardId: cardId, pagination: cardPagination, searchTerm: filters?.getTransactionDescription(), startDate: fromDate, endDate: toDate, fromAmount: filters?.fromAmount, toAmount: filters?.toAmount, movementType: movementType, cardOperationType: nil)
        switch result {
        case .success(let cardTransactionsDTO):
            var cardTransactionListsDTO = SANLegacyLibrary.CardTransactionsListDTO()
            let transactions = CardTransactionsDTOAdapter().adaptPLCardTransactionsToCardTransactionsList(cardTransactionsDTO)
            cardTransactionListsDTO = transactions
            if let next = cardTransactionsDTO.pagingLast {
                cardTransactionListsDTO.pagination.endList = false
                cardTransactionListsDTO.pagination.repositionXML = next
            } else {
                cardTransactionListsDTO.pagination.endList = true
            }
            let transactionList = CardTransactionsListEntity(cardTransactionListsDTO)
            if transactionList.transactions.count > 0 {
                return .ok(GetFilteredCardTransactionsUseCaseOkOutput(transactionList: transactionList))
            } else {
                return .error(StringErrorOutput(localized("generic_label_emptyListResult")))
            }
        case .failure(let error):
            return .error(StringErrorOutput(error.localizedDescription))
        case .none:
            return .error(StringErrorOutput(localized("generic_alert_errorCard")))
        }
    }

    private func adaptMovementType(_ movement: TransactionConceptType?) -> String? {
        switch movement {
        case .expenses:
            return "DEBIT"
        case .income:
            return "CREDIT"
        default:
            return nil
        }
    }
}

extension PLGetFilteredCardTransactionsUseCase: GetFilteredCardTransactionsUseCaseProtocol { }
