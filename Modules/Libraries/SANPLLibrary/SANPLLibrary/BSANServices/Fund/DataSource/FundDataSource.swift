//
//  FundDataSource.swift
//  SANPLLibrary
//
//  Created by Alvaro Royo on 15/1/22.
//

import Foundation
import SANLegacyLibrary

protocol FundDataSourceProtocol {
    func changeAlias(fundDTO: SANLegacyLibrary.FundDTO, newAlias: String) throws -> Result<FundChangeAliasDTO, NetworkProviderError>
    func getFundDetails(registerId: String) -> Result<FundDetailsDTO, NetworkProviderError>
    func getFundTransactions(registerId: String, language: String) -> Result<FundTransactionListDTO, NetworkProviderError>
    func getFundTransactionsFiltered(registerId: String, language: String, parameters: FundTransactionsParameters) -> Result<FundTransactionListDTO, NetworkProviderError>
}

final class FundDataSource {
    private enum FundServiceType: String {
        case changeAlias = "/accounts/productaliases"
        case detail = "/funds/register/%@/details"
        case transactions = "/funds/register/%@/history"
    }
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    private var headers: [String: String] = [:]
    private var queryParams: [String: Any]? = nil
    
    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
}

private extension FundDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

extension FundDataSource: FundDataSourceProtocol {

    func getFundDetails(registerId: String) -> Result<FundDetailsDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = String(format: FundServiceType.detail.rawValue, registerId)
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<FundDetailsDTO, NetworkProviderError> = self.networkProvider.request(FundDetailsRequest(serviceName: serviceName,
                                                                                                                   serviceUrl: absoluteUrl,
                                                                                                                   method: .get,
                                                                                                                   headers: headers,
                                                                                                                   queryParams: nil,
                                                                                                                   contentType: nil,
                                                                                                                   localServiceName: .fundDetail))
        return result
    }

    func getFundTransactions(registerId: String, language: String = "PL")  -> Result<FundTransactionListDTO, NetworkProviderError> {
        return performGetTransactions(registerId: registerId, language: language, parameters: nil)
    }
    
    func getFundTransactionsFiltered(registerId: String, language: String = "PL", parameters: FundTransactionsParameters)  -> Result<FundTransactionListDTO, NetworkProviderError> {
        return performGetTransactions(registerId: registerId, language: language, parameters: parameters)
    }
    
    func changeAlias(fundDTO: SANLegacyLibrary.FundDTO, newAlias: String) throws -> Result<FundChangeAliasDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let accountNumber = fundDTO.productId?.id,
              let systemId = fundDTO.productId?.systemId else {
                  return .failure(NetworkProviderError.other)
              }
        
        let serviceName = "\(FundServiceType.changeAlias.rawValue)/\(systemId)/\(accountNumber)"
        let absoluteUrl = baseUrl + self.basePath
        let parameters = ChangeAliasParameters(userDefined: newAlias)
        
        let result: Result<FundChangeAliasDTO, NetworkProviderError> = self.networkProvider.request(FundChangeAliasRequest(serviceName: serviceName,
                                                                                                                           serviceUrl: absoluteUrl,
                                                                                                                           method: .post,
                                                                                                                           jsonBody: parameters,
                                                                                                                           headers: self.headers,
                                                                                                                           contentType: .json,
                                                                                                                           localServiceName: .changeAlias)
        )
        return result
    }
}

private extension FundDataSource {

    func performGetTransactions(registerId: String, language: String = "PL", parameters: FundTransactionsParameters?)  -> Result<FundTransactionListDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = String(format: FundServiceType.transactions.rawValue, registerId)
        let absoluteUrl = baseUrl + self.basePath
        var filters = self.queryParams
        if let parametersData = try? JSONEncoder().encode(parameters) {
            filters = try? JSONSerialization.jsonObject(with: parametersData, options: []) as? [String : Any]
        }
        let result: Result<FundTransactionListDTO, NetworkProviderError> = self.networkProvider.request(FundTransactionsRequest(serviceName: serviceName,
                                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                                method: .get,
                                                                                                                                headers: ["Accept-Language": language],
                                                                                                                                queryParams: filters,
                                                                                                                                contentType: nil,
                                                                                                                                localServiceName: .fundTransactions))
        return result
    }
}

private struct FundDetailsRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .none
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: NetworkProviderRequestBodyEmpty? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.headers = headers
        self.queryParams = queryParams
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}

private struct FundTransactionsRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: FundTransactionsParameters? = nil
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .none
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth
    
    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: FundTransactionsParameters? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.headers = headers
        self.queryParams = queryParams
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}

private struct FundChangeAliasRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: ChangeAliasParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .body
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth
    
    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: ChangeAliasParameters?,
         headers: [String: String]?,
         queryParams: [String: String]? = nil,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.jsonBody = jsonBody
        self.headers = headers
        self.queryParams = queryParams
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}
