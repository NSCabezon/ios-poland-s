//
//  GlobalPositionDataSource.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 13/5/21.
//

import Foundation

protocol GlobalPositionDataSourceProtocol {
    func getGlobalPosition() throws -> Result<GlobalPositionDTO, NetworkProviderError>
    func getGlobalPosition(_ parameters: GlobalPositionParameters) throws -> Result<GlobalPositionDTO, NetworkProviderError>
}

private extension GlobalPositionDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class GlobalPositionDataSource {
    private enum GlobalPositionServiceType: String {
        case globalPosition = "/gps"
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
    
    private func performGetGlobalPosition() -> Result<GlobalPositionDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        
        let serviceName = GlobalPositionServiceType.globalPosition.rawValue
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<GlobalPositionDTO, NetworkProviderError> = self.networkProvider.request(GlobalPositionRequest(serviceName: serviceName,
                                                                                                                         serviceUrl: absoluteUrl,
                                                                                                                         method: .get,
                                                                                                                         headers: self.headers,
                                                                                                                         queryParams: self.queryParams,
                                                                                                                         contentType: nil,
                                                                                                                         localServiceName: .globalPosition)
        )
        return result
    }
}

extension GlobalPositionDataSource: GlobalPositionDataSourceProtocol {
    func getGlobalPosition() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        self.queryParams = nil
        let result = performGetGlobalPosition()
        return result
    }
    
    func getGlobalPosition(_ parameters: GlobalPositionParameters) throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        self.queryParams = ["types": parameters.filterBy.rawValue]
        let result = performGetGlobalPosition()
        return result
    }
}

private struct GlobalPositionRequest: NetworkProviderRequest {
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
