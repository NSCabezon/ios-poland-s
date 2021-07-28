//
//  PLAccountManager.swift
//  SANPLLibrary
//

import Foundation
import SANLegacyLibrary

public protocol PLAccountManagerProtocol {
    func getDetails(accountNumber: String, parameters: AccountDetailsParameters) throws -> Result<AccountDetailDTO, NetworkProviderError>
    func getSwiftBranches(accountNumber: String) throws -> Result<SwiftBranchesDTO, NetworkProviderError>
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
}
