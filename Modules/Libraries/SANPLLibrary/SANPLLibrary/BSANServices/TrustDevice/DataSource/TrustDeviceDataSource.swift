//
//  TrustDeviceDataSource.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 21/6/21.
//

import Foundation

protocol TrustDeviceDataSourceProtocol {
    func doRegisterDevice(_ parameters: RegisterDeviceParameters) throws -> Result<RegisterDeviceDTO, NetworkProviderError>
    func doRegisterSoftwareToken(_ parameters: RegisterSoftwareTokenParameters) throws -> Result<RegisterSoftwareTokenDTO, NetworkProviderError>
}

private extension TrustDeviceDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

class TrustDeviceDataSource: TrustDeviceDataSourceProtocol {
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api/auth/devices"
    private var headers: [String: String] = ["Santander-Channel": "MBP",
                                             "Santander-Session-Id": ""]

    private enum TrustDeviceServiceType: String {
        case registerDevice = "/registration/trusted-device"
        case registerSoftwareToken = "/registration/software-token"
    }

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }

    func doRegisterDevice(_ parameters: RegisterDeviceParameters) throws -> Result<RegisterDeviceDTO, NetworkProviderError> {
        guard let body = parameters.getURLFormData(), let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName =  TrustDeviceServiceType.registerDevice.rawValue
        let result: Result<RegisterDeviceDTO, NetworkProviderError> = self.networkProvider.request(RegisterDeviceRequest(serviceName: serviceName,
                                                                                                       serviceUrl: absoluteUrl,
                                                                                                       method: .post,
                                                                                                       body: body,
                                                                                                       jsonBody: parameters,
                                                                                                       headers: self.headers,
                                                                                                       localServiceName: .registerDeviceTrustDevice,
                                                                                                       authorization: .oauth))

        return result
    }

    func doRegisterSoftwareToken(_ parameters: RegisterSoftwareTokenParameters) throws -> Result<RegisterSoftwareTokenDTO, NetworkProviderError> {
        guard let body = parameters.getURLFormData(), let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName =  TrustDeviceServiceType.registerSoftwareToken.rawValue
        let result: Result<RegisterSoftwareTokenDTO, NetworkProviderError> = self.networkProvider.request(RegisterSoftwareTokenRequest(serviceName: serviceName,
                                                                                                                                       serviceUrl: absoluteUrl,
                                                                                                                                       method: .post,
                                                                                                                                       body: body,
                                                                                                                                       jsonBody: parameters,
                                                                                                                                       headers: self.headers,
                                                                                                                                       localServiceName: .registerSoftwareToken,
                                                                                                                                       authorization: .oauth))

        return result
    }
}

private struct RegisterDeviceRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: RegisterDeviceParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: RegisterDeviceParameters? = nil,
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

private struct RegisterSoftwareTokenRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: RegisterSoftwareTokenParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: RegisterSoftwareTokenParameters? = nil,
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
