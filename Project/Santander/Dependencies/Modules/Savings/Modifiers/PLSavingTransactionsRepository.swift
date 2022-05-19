//
//  PLSavingTransactionsRepository.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 7/4/22.
//

import Foundation
import SavingProducts
import OpenCombine
import SANPLLibrary
import CoreDomain
import CoreFoundationLib

public enum PLSavingTransactionsRepositoryProductType: String {
    case term = "TERM"
    case savingProduct = "SAVINGS"
    case goals = "GOAL"
}

final class PLSavingTransactionsRepository: SavingTransactionsRepository {
    let dependenciesResolver: DependenciesResolver
    private var pagination = PLSavingPaginationRepresentable(next: nil, current: "1")
    private var lastPage: Bool = false
    lazy var provider = {
        dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getSavingManager()
    }()
    
    public init(dependencies: DependenciesResolver) {
        self.dependenciesResolver = dependencies
    }
    
    func getTransactions(_ parameters: SavingTransactionParamsRepresentable) -> AnyPublisher<SavingTransactionsResponseRepresentable, Error> {
        guard let type = PLSavingTransactionsRepositoryProductType(rawValue: parameters.type ?? "") else {
            return Fail(error: NSError(description: "missing type")).eraseToAnyPublisher()
        }
        switch type {
        case .savingProduct:
            guard let number = parameters.contract?.contractNumber else {
                return Fail(error: NSError(description: "missing contractNumber")).eraseToAnyPublisher()
            }
            let params = SavingsTransactionsParameters(accountNumbers: [number], pagingLast: parameters.offset)
            return getSavingProductsTransactions(params, contractNumber: number)
        case .term:
            return getSavingTermTransactions(parameters)
        default:
            return Fail(error: NSError(description: "wrong product type")).eraseToAnyPublisher()
        }
    }
}

private extension PLSavingTransactionsRepository {
    func getSavingProductsTransactions(_ parameters: SavingsTransactionsParameters, contractNumber: String) -> AnyPublisher<SavingTransactionsResponseRepresentable, Error> {
        let params = SavingsTransactionsParameters(accountNumbers: [contractNumber], pagingLast: parameters.pagingLast)
        do {
            let result = try provider.loadSavingTransactions(parameters: params)
            switch result {
            case .success(let transactions):
                let page = PLSavingPaginationRepresentable(next: transactions.pagingLast)
                let data = PLSavingTransactionDataRepresentable(dtos: transactions.entries ?? [])
                let response = PLSavingTransactionsResponseRepresentable(data: data, pagination: page)
                return Just(response).tryMap({ result in
                    return result
                }).eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func getSavingTermTransactions(_ parameters: SavingTransactionParamsRepresentable) -> AnyPublisher<SavingTransactionsResponseRepresentable, Error> {
        let pagingLast = lastPage ? nil : parameters.offset
        let params = SavingsTransactionsParameters(accountNumbers: [parameters.contract?.contractNumber ?? ""],
                                                   pagingLast: pagingLast)
        do {
            let result = try provider.loadSavingTermTransactions(accountId: parameters.accountID, type: .byId, parameters: params)
            switch result {
            case .success(let transactions):
                self.lastPage = (transactions.operationList?.count ?? 0) < params.operationCount
                return Just(self.prepareResponseFor(transactions: transactions, isLast: self.lastPage)).tryMap({ result in
                    return result
                }).eraseToAnyPublisher()
            case .failure(_):
                return Just(self.prepareEmpty()).tryMap({ result in
                    return result
                }).eraseToAnyPublisher()
            }
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func prepareResponseFor(transactions: SavingTermTransactionsDTO, isLast: Bool) -> PLSavingTransactionsResponseRepresentable {
        let last = transactions.operationList?.last?.operationId
        let page = PLSavingPaginationRepresentable(next: String(format: "%@|%d", last?.postingDate ?? "", last?.operationLP ?? 1))
        let data = PLSavingTransactionDataRepresentable(termDtos: transactions.operationList ?? [])
        return PLSavingTransactionsResponseRepresentable(data: data, pagination: isLast ? nil : page)
    }
    
    func prepareEmpty() -> PLSavingTransactionsResponseRepresentable {
        let data = PLSavingTransactionDataRepresentable(termDtos: [])
        return PLSavingTransactionsResponseRepresentable(data: data, pagination: nil)
    }
}
