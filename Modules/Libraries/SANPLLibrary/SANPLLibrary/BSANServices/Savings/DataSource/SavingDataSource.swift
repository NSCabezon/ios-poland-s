//
//  SavingDataSource.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 7/4/22.
//

import Foundation
import SANLegacyLibrary

public enum GetSavingTransactionType: String {
    case byId = "get_by_id"
}

protocol SavingDataSourceProtocol {
    func loadSavingTransactions(parameters: SavingsTransactionsParameters?) throws -> Result<SavingTransactionsDTO, NetworkProviderError>
    func loadSavingTermTransactions(accountId: String, type: GetSavingTransactionType, parameters: SavingsTransactionsParameters?) throws -> Result<SavingTermTransactionsDTO, NetworkProviderError>
    func loadSavingAdditionDetails(accountId: String) throws -> Result<[SavingDetailsDTO], NetworkProviderError>
    func loadTermAdditionDetails(accountId: String) throws -> Result<TermDetailsDTO, NetworkProviderError>
}

final class SavingDataSource {
    private enum SavingServiceType: String {
        case transactionsSearch = "/history/search"
        case transactions = "/history"
        case savingDetails = "/deposits/product/bonuses-by-account/"
        case termDetails = "/deposits/"
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

extension SavingDataSource: SavingDataSourceProtocol {
    func loadSavingTermTransactions(accountId: String, type: GetSavingTransactionType, parameters: SavingsTransactionsParameters?) throws -> Result<SavingTermTransactionsDTO, NetworkProviderError> {
        guard let baseUrl = getBaseUrl(),
              let term = try? dataProvider.getSessionData().globalPositionDTO?.savings?.filter({ $0.accountId?.id == accountId }).first,
              let systemId = term.accountId?.systemId else {
            return .failure(NetworkProviderError.other)
        }
        queryParams = nil
        if let parameters = parameters, let parametersData = try? JSONEncoder().encode(parameters) {
            queryParams = try? JSONSerialization.jsonObject(with: parametersData, options: []) as? [String : Any]
        }
        if let dateTo = parameters?.pagingLast?.components(separatedBy: "|").first {
            queryParams?["dateTo"] = dateTo
        }
        if let operationLP = parameters?.pagingLast?.components(separatedBy: "|").last {
            queryParams?["operationLP"] = operationLP
        }
        queryParams?.removeValue(forKey: "pagingLast")
        let serviceName = "\(SavingServiceType.transactions.rawValue)/\(type.rawValue)/\(systemId)/\(accountId)"
        let absoluteUrl = baseUrl + basePath
        let request = SavingTermRequest(serviceName: serviceName,
                                        serviceUrl: absoluteUrl,
                                        method: .get,
                                        headers: headers,
                                        queryParams: queryParams,
                                        contentType: nil,
                                        localServiceName: .loanTransactions)
        let result: Result<SavingTermTransactionsDTO, NetworkProviderError> = networkProvider.request(request)
        return result
    }
    
    func loadSavingTransactions(parameters: SavingsTransactionsParameters?) throws -> Result<SavingTransactionsDTO, NetworkProviderError> {
        guard let baseUrl = getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = SavingServiceType.transactionsSearch.rawValue
        let absoluteUrl = baseUrl + basePath
        let request = SavingTransactionRequest(serviceName: serviceName,
                                               serviceUrl: absoluteUrl,
                                               method: .post,
                                               jsonBody: parameters,
                                               headers: headers,
                                               contentType: .json,
                                               localServiceName: .savingsTransactions)
        let result: Result<SavingTransactionsDTO, NetworkProviderError> = networkProvider.request(request)
        return result
    }

    func loadSavingAdditionDetails(accountId: String) throws -> Result<[SavingDetailsDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = SavingServiceType.savingDetails.rawValue + "\(accountId)"
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<[SavingDetailsDTO], NetworkProviderError> = self.networkProvider.request(SavingDetailsRequest(serviceName: serviceName,
                                                                                                                         serviceUrl: absoluteUrl,
                                                                                                                         method: .get,
                                                                                                                         headers: self.headers,
                                                                                                                         contentType: nil,
                                                                                                                         localServiceName: .savingDetails))
        return result
    }

    func loadTermAdditionDetails(accountId: String) throws -> Result<TermDetailsDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = SavingServiceType.termDetails.rawValue + "\(accountId)"
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<TermDetailsDTO, NetworkProviderError> = self.networkProvider.request(TermDetailsRequest(serviceName: serviceName,
                                                                                                                   serviceUrl: absoluteUrl,
                                                                                                                   method: .get,
                                                                                                                   headers: self.headers,
                                                                                                                   contentType: nil,
                                                                                                                   localServiceName: .termDetails))
        return result
    }
}

private extension SavingDataSource {
    func getBaseUrl() -> String? {
        return try? dataProvider.getEnvironment().urlBase
    }
}

private struct SavingTransactionRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: SavingsTransactionsParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .body
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth
    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: SavingsTransactionsParameters?,
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

private struct SavingTermRequest: NetworkProviderRequest {
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
         jsonBody: Encodable? = nil,
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


private struct SavingDetailsRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data? = nil
    let bodyEncoding: NetworkProviderBodyEncoding? = .none
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         headers: [String: String]?,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}

private struct TermDetailsRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = nil
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         headers: [String: String]?,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}
