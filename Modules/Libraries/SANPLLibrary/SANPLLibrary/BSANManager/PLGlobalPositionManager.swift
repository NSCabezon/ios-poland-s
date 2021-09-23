//
//  PLGlobalPositionManager.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 14/5/21.
//

import Foundation

public protocol PLGlobalPositionManagerProtocol {
    func getAllProducts() throws -> Result<GlobalPositionDTO, NetworkProviderError>
    func getAccounts() throws -> Result<GlobalPositionDTO, NetworkProviderError>
    func getCards() throws -> Result<GlobalPositionDTO, NetworkProviderError>
    func getLoans() throws -> Result<GlobalPositionDTO, NetworkProviderError>
    func getDeposits() throws -> Result<GlobalPositionDTO, NetworkProviderError>
    func getInvestmentFunds() throws -> Result<GlobalPositionDTO, NetworkProviderError>
}

final class PLGlobalPositionManager {
    private let globalPositionDataSource: GlobalPositionDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.globalPositionDataSource = GlobalPositionDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLGlobalPositionManager: PLGlobalPositionManagerProtocol {
    func getAllProducts() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        if let cachedGlobalPosition = self.getCachedGlobalPosition() {
            return .success(cachedGlobalPosition)
        }
        let result = try self.globalPositionDataSource.getGlobalPosition()
        self.processGlobalPositionResult(result)
        return result
    }
    
    func getAccounts() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        if let cachedGlobalPosition = self.getCachedGlobalPosition() {
            return .success(cachedGlobalPosition)
        }
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .accounts))
        self.processGlobalPositionResult(result)
        return result
    }
    
    func getCards() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        if let cachedGlobalPosition = self.getCachedGlobalPosition() {
            return .success(cachedGlobalPosition)
        }
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .cards))
        self.processGlobalPositionResult(result)
        return result
    }

    func getDeposits() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        if let cachedGlobalPosition = self.getCachedGlobalPosition() {
            return .success(cachedGlobalPosition)
        }
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .deposits))
        self.processGlobalPositionResult(result)
        return result
    }

    func getInvestmentFunds() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        if let cachedGlobalPosition = self.getCachedGlobalPosition() {
            return .success(cachedGlobalPosition)
        }
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .investmentFunds))
        self.processGlobalPositionResult(result)
        return result
    }

    func getLoans() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        if let cachedGlobalPosition = self.getCachedGlobalPosition() {
            return .success(cachedGlobalPosition)
        }
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .loans))
        self.processGlobalPositionResult(result)
        return result
    }
}

private extension PLGlobalPositionManager {
    private func processGlobalPositionResult(_ result: Result<GlobalPositionDTO, NetworkProviderError>) {
        if case .success(let globalPosition) = result {
            self.bsanDataProvider.store(globalPosition)
        }
    }

    private func getCachedGlobalPosition() -> GlobalPositionDTO? {
        return self.bsanDataProvider.getGlobalPosition()
    }
}
