//
//  OperationsProductsDataSource.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 27/12/21.
//

import Foundation

protocol OperationsProductsDataSourceProtocol {
    func getOperationsProducts() throws -> Result<[OperationsProductsDTO], NetworkProviderError>
}

private extension OperationsProductsDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

class OperationsProductsDataSource: OperationsProductsDataSourceProtocol {
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api/v2/operations"
    private var headers: [String: String] = ["X-Execution-Timestamp" : "\(Int(Date().timeIntervalSince1970))",
                                             "X-Application-Version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""]
    private enum OperationsProductsServiceType: String {
        case operationsProducts = "/products"
    }

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }

    func getOperationsProducts() throws -> Result<[OperationsProductsDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName =  OperationsProductsServiceType.operationsProducts.rawValue
        let request = OperationsProductsRequest(serviceName: serviceName,
                                                serviceUrl: absoluteUrl,
                                                method: .get,
                                                headers: self.headers,
                                                contentType: .json,
                                                localServiceName: .operationsProducts,
                                                authorization: .twoFactorOperation(transactionParameters: nil))
        let result: Result<[OperationsProductsDTO], NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
}

private struct OperationsProductsRequest: NetworkProviderRequest {
    
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: AuthenticateInitParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: AuthenticateInitParameters? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         headers: [String: String]?,
         contentType: NetworkProviderContentType = .json,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = nil) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.jsonBody = jsonBody
        self.bodyEncoding = bodyEncoding
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
    }
}
