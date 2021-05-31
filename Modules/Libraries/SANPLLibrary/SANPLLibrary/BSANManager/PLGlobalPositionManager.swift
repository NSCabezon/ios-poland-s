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
        let result = try globalPositionDataSource.getGlobalPosition()
        return self.performResult(result: result)
    }
    
    func getAccounts() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .accounts))
        return self.performResult(result: result)
    }
    
    func getCards() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .cards))
        return self.performResult(result: result)
    }

    func getDeposits() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .deposits))
        return self.performResult(result: result)
    }

    func getInvestmentFunds() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .investmentFunds))
        return self.performResult(result: result)
    }

    func getLoans() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .loans))
        return self.performResult(result: result)
    }
}

private extension PLGlobalPositionManager {
    private func performResult(result: Result<GlobalPositionDTO, NetworkProviderError>) -> Result<GlobalPositionDTO, NetworkProviderError> {
        switch result {
        case .failure(let error):
            return .failure(error)
        case .success(let globalPositionDTO):
            self.bsanDataProvider.store(globalPositionDTO)
            return .success(globalPositionDTO)
        }
    }
}
