//
//  HistoryDataSource.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 25/1/22.
//

import Foundation

protocol HistoryDataSourceProtocol {
    func getReceipt(receiptId: String, language: String) throws -> Result<Data, NetworkProviderError>
}

private extension HistoryDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class HistoryDataSource {
    private enum LoanServiceType: String {
        case getReceipt = "/history/receipt"
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

extension HistoryDataSource: HistoryDataSourceProtocol {

    func getReceipt(receiptId: String, language: String) throws -> Result<Data, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        self.headers = ["Accept-Language" : language]
        let absoluteUrl = baseUrl + self.basePath
        let serviceName = LoanServiceType.getReceipt.rawValue + "/" + receiptId  + "/download?type=PDF"
        let result: Result<Data, NetworkProviderError> = self.networkProvider.requestData(HistoryRequest(serviceName: serviceName,
                                                                                                     serviceUrl: absoluteUrl,
                                                                                                     method: .get,
                                                                                                     headers: self.headers,
                                                                                                     queryParams: self.queryParams,
                                                                                                     contentType: .pdf,
                                                                                                     localServiceName: .getReceipt))
        return result
    }
}

private struct HistoryRequest: NetworkProviderRequest {
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
