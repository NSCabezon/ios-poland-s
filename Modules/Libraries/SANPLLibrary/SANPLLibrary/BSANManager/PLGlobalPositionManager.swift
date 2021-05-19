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
    func getLoans() throws -> Result<GlobalPositionDTO, Error>
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
    func getAllProducts() throws -> Result<GlobalPositionDTO, Error> {
        let result = try globalPositionDataSource.getGlobalPosition()
        switch result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getAccounts() throws -> Result<GlobalPositionDTO, Error> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .accounts))
        switch result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getCards() throws -> Result<GlobalPositionDTO, Error> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .cards))
        switch result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }

    func getLoans() throws -> Result<GlobalPositionDTO, Error> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .loans))
        switch result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }
}
