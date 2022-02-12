//
//  TaxTransferDataSource.swift
//  SANPLLibrary
//
//  Created by 185167 on 11/01/2022.
//

import Foundation

protocol TaxTransferDataSourceProtocol {
    func getTaxPayers() throws -> Result<[TaxPayerDTO], NetworkProviderError>
}

final class TaxTransferDataSource {
    
    private enum TaxTransferServiceType: String {
        case payers = "/payers"
    }
    
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
    func getTaxPayers() throws -> Result<[TaxPayerDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + basePath
        let serviceName = TaxTransferServiceType.payers.rawValue
        return networkProvider.request(
            TaxTransferRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get,
                        contentType: nil)
        )
    }
}

