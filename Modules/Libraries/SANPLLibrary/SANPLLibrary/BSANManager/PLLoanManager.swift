//
//  PLLoanManager.swift
//  SANPLLibrary
//

import Foundation
import SANLegacyLibrary

public protocol PLLoanManagerProtocol {
    func getDetails(accountNumber: String, parameters: LoanDetailsParameters) throws -> Result<LoanDetailDTO, NetworkProviderError>
    func getTransactions(withAccountNumber: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError>
    func getTransactions(withAccountId: String, accountNumber: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError>
    func getInstallments(accountId: String, parameters: LoanInstallmentsParameters?) throws -> Result<LoanInstallmentsListDTO, NetworkProviderError>
}

final class PLLoanManager {
    private let loanDataSource: LoanDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.loanDataSource = LoanDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLLoanManager: PLLoanManagerProtocol {
    func getDetails(accountNumber: String, parameters: LoanDetailsParameters) throws -> Result<LoanDetailDTO, NetworkProviderError> {
        if let cachedDetail = self.getCachedDetail(accountNumber) {
            return .success(cachedDetail)
        }
        let result = try self.loanDataSource.getDetails(accountNumber: accountNumber, parameters: parameters)
        self.processDetailResult(accountNumber, result: result)
        return result
    }

    func getTransactions(withAccountNumber accountNumber: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError> {
        let result = try self.loanDataSource.getTransactions(accountNumber: accountNumber, parameters: parameters)
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

    func getInstallments(accountId: String, parameters: LoanInstallmentsParameters?) throws -> Result<LoanInstallmentsListDTO, NetworkProviderError> {
        let result = try self.loanDataSource.getInstallments(accountId: accountId, parameters: parameters)
        return result
    }
}

private extension PLLoanManager {
    private func getCachedDetail(_ accountNumber: String) -> LoanDetailDTO? {
        return self.bsanDataProvider.getLoanDetail(withLoanId: accountNumber)
    }

    private func getCachedTransactions(_ accountNumber: String) -> LoanOperationListDTO? {
        return self.bsanDataProvider.getLoanOperationList(withLoanId: accountNumber)
    }

    private func processDetailResult(_ accountNumber: String, result: Result<LoanDetailDTO, NetworkProviderError>) {
        if case .success(let loanDetail) = result {
            self.bsanDataProvider.store(loanDetail: loanDetail, forLoanId: accountNumber)
        }
    }

    private func processTransactionResult(_ accountNumber: String, result: Result<LoanOperationListDTO, NetworkProviderError>) {
        if case .success(let loanOperationList) = result {
            self.bsanDataProvider.store(loanOperationList: loanOperationList, forLoanId: accountNumber)
        }
    }
}
