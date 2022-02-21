//
//  PLOperationsProductsManager.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 28/12/21.
//

import Foundation

public protocol PLOperationsProductsManagerProtocol {
    func getOperationsProducts(useCache: Bool) throws -> Result<[OperationsProductsDTO], NetworkProviderError>
}

public final class PLOperationsProductsManager {
    private let operationsProductsDataSource: OperationsProductsDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.operationsProductsDataSource = OperationsProductsDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
    }
}

extension PLOperationsProductsManager: PLOperationsProductsManagerProtocol {
    public func getOperationsProducts(useCache: Bool) throws -> Result<[OperationsProductsDTO], NetworkProviderError> {
        
        if let cachedOperations = self.bsanDataProvider.getOperationsProducts(),
           useCache == true && cachedOperations.isEmpty == false {
            return .success(cachedOperations)
        }
        
        let result = try operationsProductsDataSource.getOperationsProducts()
        switch result {
        case .success(let operationsProductsDTO):
            self.bsanDataProvider.storeOperationsProducts(operationsProductsDTO)
        default:
            break
        }
        return result
    }
}
