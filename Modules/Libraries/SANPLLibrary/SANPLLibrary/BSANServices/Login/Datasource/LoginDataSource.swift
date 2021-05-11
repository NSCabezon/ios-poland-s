//
//  LoginDataSource.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

protocol LoginDataSourceProtocol {
    func doLoginWithNick(nick: String) throws -> Result<LoginDTO, Error>
}

private extension LoginDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

class LoginDataSource: LoginDataSourceProtocol {
    
    private let loginNickPath = "/api/as/login"
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    // TODO: Fill
    private let basePath = ""
    
    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
    
    func doLoginWithNick(nick: String) throws -> Result<LoginDTO, Error> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        
        let path = self.basePath + self.loginNickPath
        let absoluteUrl = baseUrl + path
        let serviceName =  LoginServiceType.token.rawValue
        let result: Result<LoginDTO, NetworkProviderError> = self.networkProvider.loginRequest(LoginRequest(serviceName: serviceName,
                                                                                                            serviceUrl: absoluteUrl,
                                                                                                            method: .get,
                                                                                                            body: body, headers: self.headers,
                                                                                                            contentType: .urlEncoded,
                                                                                                            localServiceName: .loginIDP)
        )
        return result
    }
}



private struct LoginRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: String]? = nil
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: Encodable? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .form,
         headers: [String: String]?,
         contentType: NetworkProviderContentType,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = nil) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.bodyEncoding = bodyEncoding
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
    }
}
