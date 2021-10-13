//
//  NotificationsDataSource.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 24/9/21.
//

import Foundation

protocol NotificationDataSourceProtocol {
    func doRegisterToken(_ parameters: NotificationRegisterParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
}

private extension NotificationDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

class NotificationDataSource: NotificationDataSourceProtocol {
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api/events/notification"
    private var headers: [String: String] = ["Santander-Channel": "MBP",
                                             "Santander-Session-Id": ""]

    private enum NotificationsServiceType: String {
        case token = "/token"
    }

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }

    func doRegisterToken(_ parameters: NotificationRegisterParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        guard let body = parameters.getURLFormData(), let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let absoluteUrl = baseUrl + self.basePath
        let serviceName =  NotificationsServiceType.token.rawValue
        let result: Result<NetworkProviderResponseWithStatus, NetworkProviderError> =
            self.networkProvider.requestDataWithStatus(NotificationRegisterRequest(serviceName: serviceName,
                                                                                   serviceUrl: absoluteUrl,
                                                                                   method: .post,
                                                                                   body: body,
                                                                                   jsonBody: parameters,
                                                                                   headers: self.headers,
                                                                                   localServiceName: .notificationTokenRegister,
                                                                                   authorization: .oauth))
        return result
    }
}

private struct NotificationRegisterRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: NotificationRegisterParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: NotificationRegisterParameters,
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
