//
//  PLAccountTransactionsPDFGeneratorProtocol.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 9/9/21.
//

import DomainCommon
import Models
import Commons
import Account
import SANPLLibrary
import PLLegacyAdapter
import Operative
import SANLegacyLibrary
import CoreDomain
import UI

final class PLAccountTransactionsPDFGeneratorProtocol: AccountTransactionsPDFGeneratorProtocol {
    
    private static let transactionsLimit = 1000
    
    lazy private var accountsHomeCoordinatorDelegate: AccountsHomeCoordinatorDelegate = {
        return self.dependenciesResolver.resolve(for: AccountsHomeCoordinatorDelegate.self)
    }()
    lazy private var plManager: BSANManagersProvider = {
        return self.dependenciesResolver.resolve(for: BSANManagersProvider.self)
    }()
    lazy private var useCaseHandler: UseCaseHandler = {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }()
    lazy private var customerManager: PLCustomerManagerProtocol = {
        return self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getCustomerManager()
    }()
    lazy private var filteredAccountTransactionsUseCase: GetFilteredAccountTransactionsUseCaseProtocol = {
        return self.dependenciesResolver.resolve(for: GetFilteredAccountTransactionsUseCaseProtocol.self)
    }()
    
    private let dependenciesResolver: DependenciesResolver
    private var pagination: PaginationEntity? = nil
    private var transactions: [AccountTransactionEntity] = []
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func generatePDF(for account: AccountEntity, withFilters: TransactionFiltersEntity?, withScaSate scaState: ScaState?) {
        self.pagination = nil
        self.transactions = []
        let customer = try? customerManager.getIndividual().get()
        self.loadNextPage(for: account, withFilters: withFilters, pagination: nil) { [weak self] in
            self?.accountsHomeCoordinatorDelegate.didGenerateTransactionsPDF(for: account, holder: self?.ownerData(from: customer), fromDate: nil, toDate: nil, transactions: self?.transactions ?? [], showDisclaimer: withFilters == nil)
        }
    }
    
    func loadNextPage(for account: AccountEntity, withFilters: TransactionFiltersEntity?, pagination: PaginationEntity?, completion: @escaping () -> Void) {
        Scenario(useCase: filteredAccountTransactionsUseCase, input: GetFilteredAccountTransactionsUseCaseInput(account: account, filters: withFilters, pagination: pagination))
            .execute(on: self.useCaseHandler)
            .onSuccess { [weak self] response in
                
                let transactionsTransformed = response.transactionList.transactions.map({ model in
                    AccountTransactionEntity(model.dto)
                })
                self?.pagination = response.transactionList.pagination
                self?.transactions.append(contentsOf: transactionsTransformed)
                
                if !(self?.pagination?.isEnd ?? false), self?.transactions.count ?? 0 < 1000 {
                    self?.loadNextPage(for: account, withFilters: withFilters, pagination: pagination, completion: completion)
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
        if let name = customer?.address?.name {
            tempString.append(name)
            tempString.append(", ")
        }
        if let street = customer?.address?.street, let propertyNo = customer?.address?.propertyNo {
            tempString.append(street)
            tempString.append(" ")
            tempString.append(propertyNo)
            tempString.append(", ")
        }
        if let zip = customer?.address?.zip, let city = customer?.address?.city {
            tempString.append(zip)
            tempString.append(" ")
            tempString.append(city)
        }
        return tempString
    }
}
