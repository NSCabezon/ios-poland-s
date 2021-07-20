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
    func getGlobalPosition() -> GlobalPositionDTO?
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
        let result = try self.globalPositionDataSource.getGlobalPosition()
        self.processResult(result)
        return result
    }
    
    func getAccounts() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .accounts))
        self.processResult(result)
        return result
    }
    
    func getCards() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .cards))
        self.processResult(result)
        return result
    }

    func getDeposits() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .deposits))
        self.processResult(result)
        return result
    }

    func getInvestmentFunds() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .investmentFunds))
        self.processResult(result)
        return result
    }

    func getLoans() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .loans))
        self.processResult(result)
        return result
    }

    func getGlobalPosition() -> GlobalPositionDTO? {
        guard let sessionData = try? self.bsanDataProvider.getSessionData(),
              let globalPosition = sessionData.globalPositionDTO else {
            return nil
        }
        return globalPosition
    }
}

private extension PLGlobalPositionManager {
    private func processResult(_ result: Result<GlobalPositionDTO, NetworkProviderError>) {
        if case .success(let globalPosition) = result {
            self.bsanDataProvider.store(globalPosition)
        }
    }
}
