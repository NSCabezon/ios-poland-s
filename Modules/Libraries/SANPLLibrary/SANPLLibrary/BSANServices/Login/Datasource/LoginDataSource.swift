//
//  LoginDataSource.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

protocol LoginDataSourceProtocol {
    func doLogin(_ parameters: LoginParameters) throws -> Result<LoginDTO, NetworkProviderError>
    func getPubKey() throws -> Result<PubKeyDTO, NetworkProviderError>
    func doAuthenticateInit(_ parameters: AuthenticateInitParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
}

private extension LoginDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

class LoginDataSource: LoginDataSourceProtocol {
    private let loginPath = "/api/as/login"
    private let pubKeyPath = "/api/as/pub_key"
    private let authenticateInitPath = "/api/as/authenticate/init"
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    // TODO: Review
    private let basePath = ""
    private var headers: [String: String] = ["Santander-Channel": "MBP",
                                             "Santander-Session-Id": ""]
    
    private enum LoginServiceType: String {
        case login = "/login"
        case pubKey = "/pubKey"
        case authenticateInit = "/authenticateInit"
    }
    
    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
    
    func doLogin(_ parameters: LoginParameters) throws -> Result<LoginDTO, NetworkProviderError> {
        guard let body = parameters.getURLFormData(), let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        
        let path = self.basePath + self.loginPath
        let absoluteUrl = baseUrl + path
        let serviceName =  LoginServiceType.login.rawValue
        let result: Result<LoginDTO, NetworkProviderError> = self.networkProvider.request(LoginRequest(serviceName: serviceName,
                                                                                                       serviceUrl: absoluteUrl,
                                                                                                       method: .post,
                                                                                                       body: body,
                                                                                                       jsonBody: parameters,
                                                                                                       headers: self.headers,
                                                                                                       localServiceName: .login))

        return result
    }

    func getPubKey() throws -> Result<PubKeyDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let path = self.basePath + self.pubKeyPath
        let absoluteUrl = baseUrl + path
        let serviceName =  LoginServiceType.pubKey.rawValue
        let result: Result<PubKeyDTO, NetworkProviderError> = self.networkProvider.request(pubKeyRequest(serviceName: serviceName,
                                                                                                            serviceUrl: absoluteUrl,
                                                                                                            method: .get,
                                                                                                            headers: self.headers,
                                                                                                            contentType: .urlEncoded,
                                                                                                            localServiceName: .pubKey)
        )
        return result
    }

    func doAuthenticateInit(_ parameters: AuthenticateInitParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        guard let body = parameters.getURLFormData(), let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let path = self.basePath + self.authenticateInitPath
        let absoluteUrl = baseUrl + path
        let serviceName =  LoginServiceType.authenticateInit.rawValue
        let result: Result<NetworkProviderResponseWithStatus, NetworkProviderError> = self.networkProvider.requestDataWithStatus(AuthenticateInitRequest(serviceName: serviceName,
                                                                                                       serviceUrl: absoluteUrl,
                                                                                                       method: .post,
                                                                                                       body: body,
                                                                                                       jsonBody: parameters,
                                                                                                       headers: self.headers,
                                                                                                       localServiceName: .authenticateInit))
        return result
    }
}

private struct LoginRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: String]? = nil
    let jsonBody: LoginParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: LoginParameters? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .body,
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

private struct pubKeyRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: String]? = nil
    let jsonBody: AuthenticateInitParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
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

private struct AuthenticateInitRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: String]? = nil
    let jsonBody: AuthenticateInitParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: AuthenticateInitParameters? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .body,
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
