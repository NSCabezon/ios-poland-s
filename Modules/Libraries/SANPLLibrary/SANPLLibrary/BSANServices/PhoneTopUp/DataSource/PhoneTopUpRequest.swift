//
//  PhoneTopUpRequest.swift
//  SANPLLibrary
//
//  Created by 188216 on 01/12/2021.
//

import Foundation

struct PhoneTopUpRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: AuthenticateInitParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         request: Data? = nil,
         queryParams: [String: Any]? = nil,
         jsonBody: AuthenticateInitParameters? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         headers: [String: String]? = [:],
         contentType: NetworkProviderContentType? = .json,
         localServiceName: PLLocalServiceName = .authenticateInit,
         authorization: NetworkProviderRequestAuthorization? = .oauth) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = request
        self.queryParams = queryParams
        self.jsonBody = jsonBody
        self.bodyEncoding = bodyEncoding
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
    }
}
