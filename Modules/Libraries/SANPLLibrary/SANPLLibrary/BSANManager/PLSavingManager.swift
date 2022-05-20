//
//  PLSavingManager.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 7/4/22.
//

import Foundation
import SANLegacyLibrary

public protocol PLSavingManagerProtocol {
    func loadSavingTransactions(parameters: SavingsTransactionsParameters?) throws -> Result<SavingTransactionsDTO, NetworkProviderError>
    func loadSavingTermTransactions(accountId: String, type: GetSavingTransactionType, parameters: SavingsTransactionsParameters?) throws -> Result<SavingTermTransactionsDTO, NetworkProviderError>
    func loadSavingAdditionDetails(accountId: String) throws -> Result<[SavingDetailsDTO], NetworkProviderError>
    func loadTermAdditionDetails(accountId: String) throws -> Result<TermDetailsDTO, NetworkProviderError>
}

final class PLSavingManager {
    private let savingDataSource: SavingDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.savingDataSource = SavingDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLSavingManager: PLSavingManagerProtocol {
    func loadSavingTransactions(parameters: SavingsTransactionsParameters?) throws -> Result<SavingTransactionsDTO, NetworkProviderError> {
        let result = try self.savingDataSource.loadSavingTransactions(parameters: parameters)
        return result
    }
    
    func loadSavingTermTransactions(accountId: String, type: GetSavingTransactionType, parameters: SavingsTransactionsParameters?) throws -> Result<SavingTermTransactionsDTO, NetworkProviderError> {
        let result = try self.savingDataSource.loadSavingTermTransactions(accountId: accountId, type: type, parameters: parameters)
        return result
    }

    func loadSavingAdditionDetails(accountId: String) throws -> Result<[SavingDetailsDTO], NetworkProviderError> {
        let result = try self.savingDataSource.loadSavingAdditionDetails(accountId: accountId)
        return result
    }

    func loadTermAdditionDetails(accountId: String) throws -> Result<TermDetailsDTO, NetworkProviderError> {
        let result = try self.savingDataSource.loadTermAdditionDetails(accountId: accountId)
        return result
    }
}
