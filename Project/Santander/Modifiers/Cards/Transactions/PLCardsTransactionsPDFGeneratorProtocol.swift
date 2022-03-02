//
//  PLCardsTransactionsPDFGeneratorProtocol.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 2/2/22.
//

import Foundation
import Cards
import CoreFoundationLib
import SANPLLibrary
import PLLegacyAdapter

final class PLCardsTransactionsPDFGeneratorProtocol: CardsTransactionsPDFGeneratorProtocol {
    private let dependenciesResolver: DependenciesResolver
    private var pagination: PaginationEntity?
    private var transactions: [CardTransactionEntityProtocol] = []
    lazy private var cardsHomeCoordinatorDelegate: CardsHomeModuleCoordinatorDelegate = {
        return self.dependenciesResolver.resolve(for: CardsHomeModuleCoordinatorDelegate.self)
    }()
    lazy private var useCaseHandler: UseCaseHandler = {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }()
    lazy private var customerManager: PLCustomerManagerProtocol = {
        return self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getCustomerManager()
    }()
    lazy private var filteredCardTransactionsUseCase: GetFilteredCardTransactionsUseCaseProtocol = {
        return self.dependenciesResolver.resolve(for: GetFilteredCardTransactionsUseCaseProtocol.self)
    }()

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    func generatePDF(for card: CardEntity, withFilters: TransactionFiltersEntity?) {
        self.pagination = nil
        self.transactions = []
        let customer = try? customerManager.getIndividual().get()
        self.loadNextPage(for: card, withFilters: withFilters, pagination: nil) { [weak self] in
            self?.cardsHomeCoordinatorDelegate.didGenerateTransactionsPDF(for: card, holder: self?.ownerData(from: customer), fromDate: nil, toDate: nil, transactions: self?.transactions ?? [], showDisclaimer: withFilters == nil)
        }
    }
    
    func loadNextPage(for card: CardEntity, withFilters: TransactionFiltersEntity?, pagination: PaginationEntity?, completion: @escaping () -> Void) {
        Scenario(useCase: filteredCardTransactionsUseCase, input: GetFilteredCardTransactionsUseCaseInput(card: card, filters: withFilters, pagination: pagination))
            .execute(on: self.useCaseHandler)
            .onSuccess { [weak self] response in
                print(response.transactionList)
                self?.pagination = response.transactionList.pagination
                self?.transactions.append(contentsOf: response.transactionList.transactions)
                if !(self?.pagination?.isEnd ?? false), self?.transactions.count ?? 0 < 1000 {
                    self?.loadNextPage(for: card, withFilters: withFilters, pagination: self?.pagination, completion: completion)
                } else {
                    completion()
                }
            }
            .onError { _ in
                completion()
            }
    }

    private func ownerData(from customer: CustomerDTO?) -> String? {
        var tempString = ""
        if let firstName = customer?.firstName {
            tempString.append(firstName)
            tempString.append(" ")
        }
        if let secondName = customer?.secondName {
            tempString.append(secondName)
            tempString.append(" ")
        }
        if let lastName = customer?.lastName {
            tempString.append(lastName)
        }
        return tempString
    }
}
