//
//  TaxTransferDataSource.swift
//  SANPLLibrary
//
//  Created by 185167 on 11/01/2022.
//

import Foundation

protocol TaxTransferDataSourceProtocol {
    func getTaxPayers() throws -> Result<[TaxPayerDTO], NetworkProviderError>
    func getPredefinedTaxAuthorities() throws -> Result<[PayeeDTO], NetworkProviderError>
    func getTaxSymbols() throws -> Result<[TaxSymbolDTO], NetworkProviderError>
    func getTaxAccounts(requestQueries: TaxAccountsRequestQueries) throws -> Result<[TaxAccountDTO], NetworkProviderError>
    func getTaxAuthorityCities(requestQueries: TaxAuthorityCitiesRequestQueries) throws -> Result<TaxAuthorityCitiesDTO, NetworkProviderError>
}

final class TaxTransferDataSource {
    
    private enum TaxTransferServiceType: String {
        case payers = "/payers"
        case payees = "/payees/account/tax"
        case taxSymbols = "/dictionaries/forms/tax"
        case taxAccounts = "/accounts/external/tax"
        case taxAuthorityCities = "/accounts/external/tax/cities"
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
    
    func getPredefinedTaxAuthorities() throws -> Result<[PayeeDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + basePath
        let serviceName = TaxTransferServiceType.payees.rawValue
        return networkProvider.request(
            TaxTransferRequest(
                serviceName: serviceName,
                serviceUrl: serviceUrl,
                method: .get,
                contentType: nil
            )
        )
    }
    
    func getTaxSymbols() throws -> Result<[TaxSymbolDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + basePath
        let serviceName = TaxTransferServiceType.taxSymbols.rawValue
        return networkProvider.request(
            TaxTransferRequest(
                serviceName: serviceName,
                serviceUrl: serviceUrl,
                method: .get,
                contentType: nil
            )
        )
    }
    
    func getTaxAccounts(requestQueries: TaxAccountsRequestQueries) throws -> Result<[TaxAccountDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + basePath
        let serviceName = TaxTransferServiceType.taxAccounts.rawValue
        let queryParams: [String: Any] = {
            var params: [String: Any] = [:]
            if let accountNumber = requestQueries.accountNumber {
                params["accountNo"] = accountNumber
            }
            if let accountName = requestQueries.accountName {
                params["name"] = accountName
            }
            if let city = requestQueries.city {
                params["city"] = city
            }
            return params
        }()
        
        return networkProvider.request(
            TaxTransferRequest(
                serviceName: serviceName,
                serviceUrl: serviceUrl,
                method: .get,
                queryParams: queryParams,
                contentType: nil
            )
        )
    }
    
    func getTaxAuthorityCities(requestQueries: TaxAuthorityCitiesRequestQueries) throws -> Result<TaxAuthorityCitiesDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + basePath
        let serviceName = TaxTransferServiceType.taxAuthorityCities.rawValue
        return networkProvider.request(
            TaxTransferRequest(
                serviceName: serviceName,
                serviceUrl: serviceUrl,
                method: .get,
                queryParams: ["type": requestQueries.taxTransferType],
                contentType: nil
            )
        )
    }
}
