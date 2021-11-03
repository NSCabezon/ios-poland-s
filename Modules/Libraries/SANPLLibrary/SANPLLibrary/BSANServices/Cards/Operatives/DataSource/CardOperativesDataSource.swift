//
//  CardOperativesDataSource.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/10/21.
//

import Foundation

protocol CardOperativeDataSourceProtocol {
    func postCardBlock(_ parameters: CardBlockParameters) throws -> Result<Void, NetworkProviderError>
    func postCardUnblock(_ parameters: CardUnblockParameters) throws -> Result<Void, NetworkProviderError>
    func postCardDisable(_ parameters: CardDisableParameters) throws -> Result<Void, NetworkProviderError>
}

private extension CardOperativesDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class CardOperativesDataSource: CardOperativeDataSourceProtocol {
    private enum CardOperativeServiceType: String {
        case cardBlock = "/cards"
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

    func postCardBlock(_ parameters: CardBlockParameters) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName = CardOperativeServiceType.cardBlock.rawValue + "/" + parameters.virtualPan + "/block"
        let result: Result<Void, NetworkProviderError> = self.networkProvider.request(CardOperativeRequest(serviceName: serviceName,
                                                                                                           serviceUrl: absoluteUrl,
                                                                                                           method: .put,
                                                                                                           jsonBody: CardOperativeReasonBodyParameters(reason: CardDisableReason.stolen.rawValue),
                                                                                                           bodyEncoding: .body,
                                                                                                           headers: self.headers,
                                                                                                           queryParams: self.queryParams,
                                                                                                           contentType: .json,
                                                                                                           localServiceName: .cardBlock)
        )
        return result
    }

    func postCardUnblock(_ parameters: CardUnblockParameters) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName = CardOperativeServiceType.cardBlock.rawValue + "/" + parameters.virtualPan + "/unblock"
        let result: Result<Void, NetworkProviderError> = self.networkProvider.request(CardOperativeRequest(serviceName: serviceName,
                                                                                                           serviceUrl: absoluteUrl,
                                                                                                           method: .put,
                                                                                                           headers: self.headers,
                                                                                                           queryParams: self.queryParams,
                                                                                                           contentType: .json,
                                                                                                           localServiceName: .cardUnblock)
        )
        return result
    }

    func postCardDisable(_ parameters: CardDisableParameters) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName = CardOperativeServiceType.cardBlock.rawValue + "/" + parameters.virtualPan + "/disable"
        let result: Result<Void, NetworkProviderError> = self.networkProvider.request(CardOperativeRequest(serviceName: serviceName,
                                                                                                           serviceUrl: absoluteUrl,
                                                                                                           method: .put,
                                                                                                           jsonBody: CardOperativeReasonBodyParameters(reason: parameters.reason.rawValue),
                                                                                                           bodyEncoding: .body,
                                                                                                           headers: self.headers,
                                                                                                           queryParams: self.queryParams,
                                                                                                           contentType: .json,
                                                                                                           localServiceName: .cardDisable)
        )
        return result
    }
}

private struct CardOperativeRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    var jsonBody: CardOperativeReasonBodyParameters? = nil
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .body
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: CardOperativeReasonBodyParameters? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.jsonBody = jsonBody
        self.formData = body
        self.headers = headers
        self.queryParams = queryParams
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}
