//
//  LoanReactiveDataRepository.swift
//  Account
//
//  Created by Juan Carlos López Robles on 12/30/21.
//

import Foundation
import CoreDomain
import OpenCombine
import CoreFoundationLib
import SANLegacyLibrary

public protocol PLLoansManagerAdapterProtocol {
    func getLoanTransactionDetail(contractDescription: String?, transactionNumber: String?) throws -> BSANResponse<LoanTransactionDetailDTO>
}

final class LoanReactiveDataRepository {
    private let loanDataSource: LoanDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let loansManager: PLLoansManagerAdapterProtocol
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, loansManager: PLLoansManagerAdapterProtocol) {
        self.loanDataSource = LoanDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.loansManager = loansManager
    }
}

extension LoanReactiveDataRepository: LoanReactiveRepository {
    func loadDetail(loan: LoanRepresentable) -> AnyPublisher<LoanDetailRepresentable, Error> {
        Future<LoanDetailRepresentable, Error> { promise in
            let loanDetailsParameters = LoanDetailsParameters(
                includeDetails: true, includePermissions: true, includeFunctionalities: true
            )
            Async(queue: .global(qos: .background)) {
                do {
                    let loanDetails = try self.getDetails(loan: loan, parameters: loanDetailsParameters).get()
                    let _ = try self.getInstallments(accountId: loanDetails.id ?? "", parameters: nil).get()
                    promise(.success(loanDetails))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func loadTransactions(loan: LoanRepresentable, page: PaginationRepresentable?, filters: TransactionFiltersRepresentable?) -> AnyPublisher<LoanResultPageRepresentable, Error> {
        Future<LoanResultPageRepresentable, Error> { promise in
            Async(queue: .global(qos: .background)) {
                do {
                    let parameters = self.getLoanTransactionParameters(filters: filters)
                    let result = try self.getTransactions(loan: loan, parameters: parameters).get()
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func loadTransactionDetail(transaction: LoanTransactionRepresentable, loan: LoanRepresentable) -> AnyPublisher<LoanTransactionDetailRepresentable, Error> {
        
        return Future<LoanTransactionDetailRepresentable, Error> { promise in
            Async(queue: .global(qos: .background)) {
                do {
                    let result = try self.getLoanTransactionDetail(forLoan: loan,
                                                              transaction: transaction)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}

private extension LoanReactiveDataRepository {
    func getDetails(loan: LoanRepresentable, parameters: LoanDetailsParameters) throws -> Result<LoanDetailDTO, NetworkProviderError> {
        guard let accountNumber = loan.contractDescription?.replace(" ", "") else {
            throw SomeError()
        }
        if let cachedDetail = self.getCachedDetail(accountNumber) {
            return .success(cachedDetail)
        }
        let result = try self.loanDataSource.getDetails(accountNumber: accountNumber, parameters: parameters)
        self.processDetailResult(accountNumber, result: result)
        return result
    }

    func getTransactions(loan: LoanRepresentable, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError> {
        
        guard let accountNumber = loan.contractDescription?.replace(" ", "") else {
            throw SomeError()
        }
                    
        let result = try self.loanDataSource.getTransactions(accountNumber: accountNumber, parameters: parameters)
        self.processTransactionResult(accountNumber, result: result)
        
        if try result.get().transactions.isEmpty {
            throw SomeError(errorDescription: "generic_label_emptyListResult")
        }
        return result
    }

    func getTransactions(withAccountId accountId: String, accountNumber: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError> {
        if let cachedTransactions = self.getCachedTransactions(accountNumber) {
            return .success(cachedTransactions)
        }
        let result = try self.loanDataSource.getTransactions(accountId: accountId, parameters: parameters)
        self.processTransactionResult(accountNumber, result: result)
        return result
    }
    
    func getLoanTransactionDetail(forLoan loan: LoanRepresentable, transaction: LoanTransactionRepresentable) throws -> LoanTransactionDetailRepresentable {
        let response = try loansManager.getLoanTransactionDetail(contractDescription: loan.contractDescription,
                                                                 transactionNumber: transaction.transactionNumber)
        guard let result = try response.getResponseData() else {
            throw SomeError()
        }
        return result
    }


    func getInstallments(accountId: String, parameters: LoanInstallmentsParameters?) throws -> Result<LoanInstallmentsListDTO, NetworkProviderError> {
        let result = try self.loanDataSource.getInstallments(accountId: accountId, parameters: parameters)
        return result
    }
    
    
    func getCachedDetail(_ accountNumber: String) -> LoanDetailDTO? {
        return self.bsanDataProvider.getLoanDetail(withLoanId: accountNumber)
    }

    func getCachedTransactions(_ accountNumber: String) -> LoanOperationListDTO? {
        return self.bsanDataProvider.getLoanOperationList(withLoanId: accountNumber)
    }

    func processDetailResult(_ accountNumber: String, result: Result<LoanDetailDTO, NetworkProviderError>) {
        if case .success(let loanDetail) = result {
            self.bsanDataProvider.store(loanDetail: loanDetail, forLoanId: accountNumber)
        }
    }

    func processTransactionResult(_ accountNumber: String, result: Result<LoanOperationListDTO, NetworkProviderError>) {
        if case .success(let loanOperationList) = result {
            self.bsanDataProvider.store(loanOperationList: loanOperationList, forLoanId: accountNumber)
        }
    }
    
    func getLoanTransactionParameters(filters: TransactionFiltersRepresentable?) -> LoanTransactionParameters? {
        if let filters = filters {
            let paramsWithFilters = LoanTransactionParameters(
                dateFrom: filters.dateInterval?.start.toString(.YYYYMMDD),
                dateTo: filters.dateInterval?.end.toString(.YYYYMMDD),
                amountFrom: filters.fromAmount,
                amountTo: filters.toAmount
            )
            return paramsWithFilters
        }
        return nil
    }
}

