//
//  PLLoanManager.swift
//  SANPLLibrary
//

import Foundation
import SANLegacyLibrary

public protocol PLLoanManagerProtocol {
    func getDetails(accountId: String, parameters: LoanDetailsParameters) throws -> Result<LoanDetailDTO, NetworkProviderError>
    func getTransactions(accountNumber: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError>
    func getTransactions(accountId: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError>
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
    func getDetails(accountId: String, parameters: LoanDetailsParameters) throws -> Result<LoanDetailDTO, NetworkProviderError> {
        let result = try self.loanDataSource.getDetails(accountId: accountId, parameters: parameters)
        return result
    }

    func getTransactions(accountNumber: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError> {
        let result = try self.loanDataSource.getTransactions(accountNumber: accountNumber, parameters: parameters)
        return result
    }

    func getTransactions(accountId: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError> {
        let result = try self.loanDataSource.getTransactions(accountId: accountId, parameters: parameters)
        return result
    }

    func getInstallments(accountId: String, parameters: LoanInstallmentsParameters?) throws -> Result<LoanInstallmentsListDTO, NetworkProviderError> {
        let result = try self.loanDataSource.getInstallments(accountId: accountId, parameters: parameters)
        return result
    }
}
