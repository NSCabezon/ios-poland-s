//
//  PLGlobalPositionManager.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 14/5/21.
//

import Foundation

public protocol PLGlobalPositionManagerProtocol {
    func getAllProducts() throws -> Result<GlobalPositionDTO, Error>
    func getAccounts() throws -> Result<GlobalPositionDTO, Error>
    func getCards() throws -> Result<GlobalPositionDTO, Error>
    func getDeposits() throws -> Result<GlobalPositionDTO, Error>
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

    private func processResult(_ result: Result<GlobalPositionDTO, NetworkProviderError>) -> Result<GlobalPositionDTO, Error> {
        switch result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension PLGlobalPositionManager: PLGlobalPositionManagerProtocol {
    func getAllProducts() throws -> Result<GlobalPositionDTO, Error> {
        let result = try globalPositionDataSource.getGlobalPosition()
        return self.processResult(result)
    }
    
    func getAccounts() throws -> Result<GlobalPositionDTO, Error> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .accounts))
        return self.processResult(result)
    }
    
    func getCards() throws -> Result<GlobalPositionDTO, Error> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .cards))
        return self.processResult(result)
    }

    func getDeposits() throws -> Result<GlobalPositionDTO, Error> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .deposits))
        return self.processResult(result)
    }
}
