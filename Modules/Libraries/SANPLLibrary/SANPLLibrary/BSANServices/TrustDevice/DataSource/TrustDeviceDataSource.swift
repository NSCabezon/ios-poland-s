//
//  TrustDeviceDataSource.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 21/6/21.
//

import Foundation

protocol TrustDeviceDataSourceProtocol {
    func doBeforeLogin(_ parameters: BeforeLoginParameters) throws -> Result<BeforeLoginDTO, NetworkProviderError>
    func doRegisterDevice(_ parameters: RegisterDeviceParameters) throws -> Result<RegisterDeviceDTO, NetworkProviderError>
    func doRegisterSoftwareToken(_ parameters: RegisterSoftwareTokenParameters) throws -> Result<RegisterSoftwareTokenDTO, NetworkProviderError>
    func doRegisterIvr(_ parameters: RegisterIvrParameters) throws -> Result<Data, NetworkProviderError>
    func doRegisterConfirmationCode(_ parameters: RegisterConfirmationCodeParameters) throws -> Result<Void, NetworkProviderError>
    func getDevices() throws -> Result<DevicesDTO, NetworkProviderError>
    func doRegisterConfirm(_ parameters: RegisterConfirmParameters) throws -> Result<ConfirmRegistrationDTO, NetworkProviderError>
    func getPendingChallenge(_ parameters: PendingChallengeParameters) throws -> Result<PendingChallengeDTO, NetworkProviderError>
    func doConfirmChallenge(_ parameters: ConfirmChallengeParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
    func getTrustedDeviceInfo(_ parameters: TrustedDeviceInfoParameters) throws -> Result<TrustedDeviceInfoDTO, NetworkProviderError>
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
        case registerIVR = "/registration/ivr"
        case registerConfirmationCode = "/registration/send-confirmation-code"
        case registerConfirm = "/registration/confirm"
        case beforeLogin = "/trusted-devices/before-login"
        case pendingChallenge = "/mobile-authorization/pending-challenge/before-login"
        case confirmChallenge = "/mobile-authorization/confirm/before-login"
        case info = "/trusted-devices/info"
    }

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
    
    func getTrustedDeviceInfo(_ parameters: TrustedDeviceInfoParameters) throws -> Result<TrustedDeviceInfoDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let absoluteUrl = baseUrl + self.basePath
        let serviceName =  TrustDeviceServiceType.info.rawValue + "/" + parameters.trustedDeviceAppId
        let networkRequest = TrustedDeviceInfoRequest(serviceName: serviceName,
                                                      serviceUrl: absoluteUrl,
                                                      method: .get,
                                                      headers: self.headers,
                                                      localServiceName: .trustedDeviceInfo,
                                                      authorization: .oauth)
        let result: Result<TrustedDeviceInfoDTO, NetworkProviderError> = self.networkProvider.request(networkRequest)
        return result
    }
    
    func doBeforeLogin(_ parameters: BeforeLoginParameters) throws -> Result<BeforeLoginDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let absoluteUrl = baseUrl + self.basePath
        let serviceName =  TrustDeviceServiceType.beforeLogin.rawValue + "?trustedDeviceAppId=" + parameters.trustedDeviceAppId + parameters.retrieveOptions.flatMap({ option in
                return "&retrieveOptions=\(option)"
        })
        let networkRequest = BeforeLoginRequest(serviceName: serviceName,
                                                serviceUrl: absoluteUrl,
                                                method: .get,
                                                headers: self.headers,
                                                localServiceName: .beforeLogin,
                                                authorization: .none)
        let result: Result<BeforeLoginDTO, NetworkProviderError> = self.networkProvider.request(networkRequest)
        return result
    }
    
    func getPendingChallenge(_ parameters: PendingChallengeParameters) throws -> Result<PendingChallengeDTO, NetworkProviderError> {
        guard let body = parameters.getURLFormData(), let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName = TrustDeviceServiceType.pendingChallenge.rawValue
        let result: Result<PendingChallengeDTO, NetworkProviderError> = self.networkProvider.request(PendingChallengeRequest(serviceName: serviceName,
                                                                                                             serviceUrl: absoluteUrl,
                                                                                                             method: .post,
                                                                                                             body: body,
                                                                                                             jsonBody: parameters,
                                                                                                             headers: self.headers,
                                                                                                             localServiceName: .pendingChallenge,
                                                                                                             authorization: .trustedDeviceOnly))
        return result
    }
    
    func doConfirmChallenge(_ parameters: ConfirmChallengeParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        guard let body = parameters.getURLFormData(), let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName = TrustDeviceServiceType.confirmChallenge.rawValue
        let result: Result<NetworkProviderResponseWithStatus, NetworkProviderError> = self.networkProvider.requestDataWithStatus(ConfirmChallengeRequest(serviceName: serviceName,
                                                                                                                                                         serviceUrl: absoluteUrl,
                                                                                                                                                         method: .post,
                                                                                                                                                         body: body,
                                                                                                                                                         jsonBody: parameters,
                                                                                                                                                         headers: self.headers,
                                                                                                                                                         localServiceName: .confirmChallenge,
                                                                                                                                                         authorization: .trustedDeviceOnly))
        return result
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
    
    func doRegisterIvr(_ parameters: RegisterIvrParameters) throws -> Result<Data, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName = TrustDeviceServiceType.registerIVR.rawValue + "/" + parameters.trustedDeviceId
        let networkRequest = RegisterIvrRequest(serviceName: serviceName,
                                                serviceUrl: absoluteUrl,
                                                method: .post,
                                                headers: self.headers,
                                                localServiceName: .registerIVR,
                                                authorization: .oauth)
        let result: Result<Data, NetworkProviderError> = self.networkProvider.requestData(networkRequest)
        return result
    }
    
    func doRegisterConfirmationCode(_ parameters: RegisterConfirmationCodeParameters) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName = TrustDeviceServiceType.registerConfirmationCode.rawValue + "/" + parameters.trustedDeviceId + "/" + parameters.secondFactorSmsChallenge + "/" + parameters.language
        let networkRequest = RegisterConfirmationCodeRequest(serviceName: serviceName,
                                                serviceUrl: absoluteUrl,
                                                method: .post,
                                                headers: self.headers,
                                                localServiceName: .registerConfirmationCode,
                                                authorization: .oauth)
        let result: Result<Void, NetworkProviderError> = self.networkProvider.request(networkRequest)
        return result
    }
    
    func getDevices() throws -> Result<DevicesDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let absoluteUrl = baseUrl + self.basePath
        let networkRequest = DevicesRequest(serviceName: "",
                                                serviceUrl: absoluteUrl,
                                                method: .get,
                                                headers: self.headers,
                                                localServiceName: .devices,
                                                authorization: .oauth)
        let result: Result<DevicesDTO, NetworkProviderError> = self.networkProvider.request(networkRequest)
        return result
    }

    func doRegisterConfirm(_ parameters: RegisterConfirmParameters) throws -> Result<ConfirmRegistrationDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let absoluteUrl = baseUrl + self.basePath
        let networkRequest = ConfirmRegistrationRequest(serviceName: TrustDeviceServiceType.registerConfirm.rawValue,
                                                        serviceUrl: absoluteUrl,
                                                        method: .post,
                                                        headers: self.headers,
                                                        jsonBody: parameters,
                                                        localServiceName: .registerConfirm,
                                                        authorization: .oauth)
        let result: Result<ConfirmRegistrationDTO, NetworkProviderError> = self.networkProvider.request(networkRequest)
        return result
    }
}

private struct BeforeLoginRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data? = nil
    let bodyEncoding: NetworkProviderBodyEncoding? = nil
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         headers: [String: String]?,
         contentType: NetworkProviderContentType = .json,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = nil) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
    }
}

private struct TrustedDeviceInfoRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data? = nil
    let bodyEncoding: NetworkProviderBodyEncoding? = nil
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         headers: [String: String]?,
         contentType: NetworkProviderContentType = .json,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = nil) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
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

private struct RegisterIvrRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data? = nil
    let bodyEncoding: NetworkProviderBodyEncoding? = nil
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         headers: [String: String]?,
         contentType: NetworkProviderContentType = .json,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = nil) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
    }
}

private struct RegisterConfirmationCodeRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data? = nil
    let bodyEncoding: NetworkProviderBodyEncoding? = nil
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         headers: [String: String]?,
         contentType: NetworkProviderContentType = .json,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = nil) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
    }
}

private struct DevicesRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data? = nil
    let bodyEncoding: NetworkProviderBodyEncoding? = nil
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         headers: [String: String]?,
         contentType: NetworkProviderContentType = .json,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = nil) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
    }
}

private struct ConfirmRegistrationRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: RegisterConfirmParameters?
    let formData: Data? = nil
    let bodyEncoding: NetworkProviderBodyEncoding? = .body
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         headers: [String: String]?,
         contentType: NetworkProviderContentType = .json,
         jsonBody: RegisterConfirmParameters?,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = nil) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
        self.jsonBody = jsonBody
    }
}

private struct PendingChallengeRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: PendingChallengeParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: PendingChallengeParameters? = nil,
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
