//
//  BLIKTransactionViewModelProvider.swift
//  BLIK
//
//  Created by 185167 on 19/11/2021.
//

import CoreFoundationLib
import Foundation
import SANPLLibrary

protocol BLIKTransactionViewModelProviding {
    func getViewModel(_ completion: @escaping (Result<BLIKTransactionViewModel, Swift.Error>) -> ())
}

final class PrefetchedBLIKTransactionViewModelProvider: BLIKTransactionViewModelProviding {
    private let viewModel: BLIKTransactionViewModel
    
    init(viewModel: BLIKTransactionViewModel) {
        self.viewModel = viewModel
    }
    
    func getViewModel(_ completion: @escaping (Result<BLIKTransactionViewModel, Swift.Error>) -> ()) {
        completion(.success(viewModel))
    }
}

final class BLIKTransactionViewModelAsyncProvider: BLIKTransactionViewModelProviding {
    enum Error: Swift.Error {
        typealias FailureReason = String
        case selfDeallocated
        case failedToFetchTransaction(FailureReason)
    }
    private let dependenciesResolver: DependenciesResolver
    private var transactionMapper: TransactionMapping {
        dependenciesResolver.resolve()
    }
    private var getTransactionUseCase: GetTrnToConfProtocol {
        dependenciesResolver.resolve()
    }
    private var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func getViewModel(_ completion: @escaping (Result<BLIKTransactionViewModel, Swift.Error>) -> ()) {
        Scenario(useCase: getTransactionUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                guard let strongSelf = self else {
                    completion(.failure(Error.selfDeallocated))
                    return
                }
                do {
                    let transaction = try strongSelf.transactionMapper.map(dto: output.transaction)
                    let viewModel = BLIKTransactionViewModel(transaction: transaction)
                    completion(.success(viewModel))
                } catch {
                    completion(.failure(error))
                }
            }
            .onError { error in
                let mappedError = Error.failedToFetchTransaction(error.localizedDescription)
                completion(.failure(mappedError))
            }
    }
}
