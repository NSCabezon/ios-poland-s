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
        let result = try self.globalPositionDataSource.getGlobalPosition()
        processResult(result)
        return result
    }
    
    func getAccounts() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .accounts))
        processResult(result)
        return result
    }
    
    func getCards() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .cards))
        processResult(result)
        return result
    }

    func getDeposits() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .deposits))
        processResult(result)
        return result
    }

    func getInvestmentFunds() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .investmentFunds))
        processResult(result)
        return result
    }

    func getLoans() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try self.globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .loans))
        processResult(result)
        return result
    }
}

private extension PLGlobalPositionManager {
    private func processResult(_ result: Result<GlobalPositionDTO, NetworkProviderError>) {
        switch result {
        case .failure(_):
            return
        case .success(let globalPositionDTO):
            self.bsanDataProvider.store(globalPositionDTO)
        }
    }
}
