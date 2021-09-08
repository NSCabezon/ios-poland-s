//
//  CustomerDataSource.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 7/9/21.
//

import Foundation
import SANLegacyLibrary

protocol CustomerDataSourceProtocol {
    func getIndividual() throws -> Result<CustomerDTO, NetworkProviderError>
}

private extension CustomerDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class CustomerDataSource {
    private enum CustomerServiceType: String {
        case individual = "/customers/individual"
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

extension CustomerDataSource: CustomerDataSourceProtocol {
    func getIndividual() throws -> Result<CustomerDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        
        let serviceName = CustomerServiceType.individual.rawValue
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<CustomerDTO, NetworkProviderError> = self.networkProvider.request(CustomerRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: self.queryParams,
                                                                                                                contentType: .urlEncoded,
                                                                                                                localServiceName: .customerIndividual)
        )
        return result
    }
}

private struct CustomerRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .none
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth
    
    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: Encodable? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType,
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
