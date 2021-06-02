//
//  PLLoanManager.swift
//  SANPLLibrary
//

import Foundation

public protocol PLLoanManagerProtocol {
    func getAllProducts() throws -> Result<LoanTransactionsListDTO, NetworkProviderError>
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
    func getAllProducts() throws -> Result<LoanTransactionsListDTO, NetworkProviderError> {
        let result = try self.loanDataSource.getTransactions()
        return result
    }
}
