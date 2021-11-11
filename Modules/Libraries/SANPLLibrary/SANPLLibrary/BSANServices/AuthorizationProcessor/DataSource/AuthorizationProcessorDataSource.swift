//
//  AuthorizationProcessorDataSource.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 5/11/21.
//

import Foundation
import SANLegacyLibrary

protocol AuthorizationProcessorDataSourceProtocol {
    func doAuthorizeOperation(authorizationId: String, scope: String) -> AuthorizeOperationDTO
    func getPendingChallenge() throws -> Result<PendingChallengeDTO, NetworkProviderError>
    func doConfirmChallenge(_ parameters: ConfirmChallengeParameters, authorizationId: String) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
    func getIsChallengeConfirmed(authorizationID: String) throws -> Result<Void, NetworkProviderError>
}

private extension AuthorizationProcessorDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class AuthorizationProcessorDataSource {
    private enum TransferServiceType: String {
        case pendingChallenge = "/auth/devices/mobile-authorization/pending-challenge"
        case confirmChallenge = "/auth/devices/mobile-authorization/confirm/"
        case isConfirmChallenge = "/auth/devices/mobile-authorization/is-confirmed/"
    }
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    private let urlScheme = "santanderRetail"
    private var headers: [String: String] = [:]

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
}

extension AuthorizationProcessorDataSource: AuthorizationProcessorDataSourceProtocol {
    func doAuthorizeOperation(authorizationId: String, scope: String) -> AuthorizeOperationDTO {
        let redirectUrl = "\(urlScheme)://authorisation/stoneauth/init?id=\(authorizationId)&scope=\(scope)"
        let result = AuthorizeOperationDTO(uri: redirectUrl)
        return result
    }
    
    func getPendingChallenge() throws -> Result<PendingChallengeDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName: TransferServiceType = .pendingChallenge
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<PendingChallengeDTO, NetworkProviderError> = self.networkProvider.request(AuthPendingChallengeRequest(serviceName: serviceName.rawValue,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .post,
                                                                                                                headers: self.headers,
                                                                                                                contentType: .json,
                                                                                                                localServiceName: .pendingChallenge))
        return result
    }
    
    func doConfirmChallenge(_ parameters: ConfirmChallengeParameters, authorizationId: String) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        guard let body = parameters.getURLFormData(), let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName: String = TransferServiceType.confirmChallenge.rawValue + authorizationId
        let result: Result<NetworkProviderResponseWithStatus, NetworkProviderError> = self.networkProvider.requestDataWithStatus(ConfirmChallengeRequest(serviceName: serviceName,
                                                                                                                                                         serviceUrl: absoluteUrl,
                                                                                                                                                         method: .post,
                                                                                                                                                         body: body,
                                                                                                                                                         jsonBody: parameters,
                                                                                                                                                         headers: self.headers,
                                                                                                                                                         localServiceName: .confirmChallenge))
        return result
    }
    func getIsChallengeConfirmed(authorizationID: String) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = TransferServiceType.isConfirmChallenge.rawValue + authorizationID
        let absoluteUrl = baseUrl + basePath
        let result: Result<Void, NetworkProviderError> = self.networkProvider.request(AuthPendingChallengeRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                contentType: .json,
                                                                                                                localServiceName: .confirmChallenge))
        return result
    }
}

private struct AuthPendingChallengeRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: PendingChallengeParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: PendingChallengeParameters? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         contentType: NetworkProviderContentType,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.jsonBody = jsonBody
        self.method = method
        self.formData = body
        self.headers = headers
        self.queryParams = queryParams
        self.bodyEncoding = bodyEncoding
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}

private struct ConfirmChallengeRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: ConfirmChallengeParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: ConfirmChallengeParameters? = nil,
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
