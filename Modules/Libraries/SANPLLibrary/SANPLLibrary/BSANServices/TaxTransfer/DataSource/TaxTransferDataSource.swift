//
//  TaxTransferDataSource.swift
//  SANPLLibrary
//
//  Created by 185167 on 11/01/2022.
//

import Foundation

protocol TaxTransferDataSourceProtocol {
}

final class TaxTransferDataSource {
    
    // MARK: Properties
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    
    // MARK: Lifecycle
    
    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
    
    // MARK: Methods
    
    private func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

extension TaxTransferDataSource: TaxTransferDataSourceProtocol {
}

