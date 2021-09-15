//
//  PLAccountManager.swift
//  SANPLLibrary
//

import Foundation
import SANLegacyLibrary

public protocol PLAccountManagerProtocol {
    func getDetails(accountNumber: String, parameters: AccountDetailsParameters) throws -> Result<AccountDetailDTO, NetworkProviderError>
    func getSwiftBranches(accountNumber: String) throws -> Result<SwiftBranchesDTO, NetworkProviderError>
    func getWithholdingList(accountNumber: String) throws -> Result<SANPLLibrary.WithholdingListDTO, NetworkProviderError>
    func loadAccountTransactions(parameters: AccountTransactionsParameters?) throws -> Result<AccountTransactionsDTO, NetworkProviderError>
}

final class PLAccountManager {
    private let accountDataSource: AccountDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.accountDataSource = AccountDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLAccountManager: PLAccountManagerProtocol {
    func getDetails(accountNumber: String, parameters: AccountDetailsParameters) throws -> Result<AccountDetailDTO, NetworkProviderError> {
        if let cachedDetail = self.getCachedDetail(accountNumber) {
            return .success(cachedDetail)
        }
        let result = try self.accountDataSource.getDetails(accountNumber: accountNumber, parameters: parameters)
        self.processDetailResult(accountNumber, result: result)
        return result
    }

    func getSwiftBranches(accountNumber: String) throws -> Result<SwiftBranchesDTO, NetworkProviderError> {
        if let cachedSwiftBranches = self.getCachedSwiftBranches(accountNumber) {
            return .success(cachedSwiftBranches)
        }
        let result = try self.accountDataSource.getSwiftBranches(accountNumber: accountNumber)
        self.processSwiftBranchesResult(accountNumber, result: result)
        return result
    }
    
    func getWithholdingList(accountNumber: String) throws -> Result<SANPLLibrary.WithholdingListDTO, NetworkProviderError> {
        if let cachedWithholdingList = self.getCachedWithholdingList(accountNumber) {
            return .success(cachedWithholdingList)
        }
        
        let accountNumbers = [accountNumber]
        let result = try self.accountDataSource.getWithholdingList(accountNumbers: accountNumbers)
        self.processWithholdingListResult(accountNumber, result: result)
        return result
    }

    func loadAccountTransactions(parameters: AccountTransactionsParameters?) throws -> Result<AccountTransactionsDTO, NetworkProviderError> {
        let result = try self.accountDataSource.loadAccountTransactions(parameters: parameters)
        return result
    }
}

private extension PLAccountManager {
    private func getCachedDetail(_ accountNumber: String) -> AccountDetailDTO? {
        return self.bsanDataProvider.getAccountDetail(withAccountId: accountNumber)
    }

    private func processDetailResult(_ accountNumber: String, result: Result<AccountDetailDTO, NetworkProviderError>) {
        if case .success(let accountDetail) = result {
            self.bsanDataProvider.store(accountDetail: accountDetail, forAccountId: accountNumber)
        }
    }

    private func getCachedSwiftBranches(_ accountNumber: String) -> SwiftBranchesDTO? {
        return self.bsanDataProvider.getSwiftBranches(withAccountId: accountNumber)
    }

    private func processSwiftBranchesResult(_ accountNumber: String, result: Result<SwiftBranchesDTO, NetworkProviderError>) {
        if case .success(let swiftBranches) = result {
            self.bsanDataProvider.store(swiftBranches: swiftBranches, forAccountId: accountNumber)
        }
    }
    
    private func getCachedWithholdingList(_ accountNumber: String) -> WithholdingListDTO? {
        return self.bsanDataProvider.getWithholdingList(withAccountId: accountNumber)
    }
    
    private func processWithholdingListResult(_ accountNumber: String, result: Result<WithholdingListDTO, NetworkProviderError>) {
        if case .success(let withholdingListDTO) = result {
            self.bsanDataProvider.store(withholdingListDTO: withholdingListDTO, forAccountId: accountNumber)
        }
    }
}
