//
//  PLContextDTO.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 18/10/21.
//

import Foundation
import SANPLLibrary

public struct PLContextDTO: Codable {
    public let accessTokenInfo: AuthenticateDTO
    public let profileId, channel, applicationId, ownerCif, ownerId, logonType: String
}

public struct PLContextRequest: NetworkProviderRequest {
    public let serviceName: String
    public let serviceUrl: String
    public let method: NetworkProviderMethod
    public let headers: [String: String]?
    public let queryParams: [String: Any]? = nil
    public let jsonBody: AuthenticateInitParameters?
    public let formData: Data?
    public let bodyEncoding: NetworkProviderBodyEncoding?
    public let contentType: NetworkProviderContentType?
    public let localServiceName: PLLocalServiceName
    public let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: AuthenticateInitParameters? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         headers: [String: String]?,
         contentType: NetworkProviderContentType? = .json,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = .oauth) {
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
