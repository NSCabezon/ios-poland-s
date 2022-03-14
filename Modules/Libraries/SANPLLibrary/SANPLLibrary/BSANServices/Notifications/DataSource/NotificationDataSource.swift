//
//  NotificationsDataSource.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 24/9/21.
//

import Foundation

protocol NotificationDataSourceProtocol {
    func doRegisterToken(_ parameters: NotificationRegisterParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
    func getPushList(_ parameters: NotificationGetPushListParameters) throws -> Result<PLNotificationListDTO, NetworkProviderError>
    func getPushDetails(_ parameters: NotificationGetPushDetailsParameters) throws -> Result<PLNotificationDTO, NetworkProviderError>
    func getPushDetailsBeforeLogin(pushId: Int, parameters: NotificationGetPushDetailsBeforeLoginParameters) throws -> Result<PLNotificationDTO, NetworkProviderError>
    func getPushUnreadedCount(_ parameters: NotificationGetPushListParameters) throws -> Result<PLUnreadedPushCountDTO, NetworkProviderError>
    func getEnabledPushCategoriesByDevice(_ parameters: NotificationGetPushListParameters) throws -> Result<PLEnabledPushCategoriesDTO, NetworkProviderError>
    
    func postPushStatus(_ parameters: PLPushStatusUseCaseInput) throws -> Result<PLPushStatusResponseDTO, NetworkProviderError>
    func postPushStatusBeforeLogin(_ parameters: PLPushStatusUseCaseInput) throws -> Result<PLPushStatusResponseDTO, NetworkProviderError>
    func postPushListPageSize(_ parameters: NotificationPostPushListPageSizeParameters) throws -> Result<PLNotificationListDTO, NetworkProviderError>
    func postSetAllPushStatus(_ parameters: PLPushSetAllStatusUseCaseInput) throws -> Result<Void, NetworkProviderError>
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
        case list = "/list"
        case unreadedCount = "/count"
        case categories = "/categories"
        case set = "/set"
        case setAll = "/setAll"
    }
    
    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
    
    func doRegisterToken(_ parameters: NotificationRegisterParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        guard
            let body = parameters.getURLFormData(),
            let baseUrl = self.getBaseUrl()
        else {
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
    
    
    func getPushList(_ parameters: NotificationGetPushListParameters) throws -> Result<PLNotificationListDTO, NetworkProviderError> {
        guard
            let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        
        let absoluteUrl = baseUrl + "/api/notification/pushquery/auth"
        let serviceName =  "\(NotificationsServiceType.list.rawValue)/\(parameters.deviceId)"
        
        let request = NotificationGetPushListRequest(serviceName: serviceName,
                                                     serviceUrl: absoluteUrl,
                                                     method: .get,
                                                     headers: self.headers,
                                                     localServiceName: .notificationTokenRegister,
                                                     authorization: .oauth)
        
        let result: Result<PLNotificationListDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
    
    func getPushDetails(_ parameters: NotificationGetPushDetailsParameters) throws -> Result<PLNotificationDTO, NetworkProviderError> {
        guard
            let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        
        let absoluteUrl = baseUrl + "/api/notification/pushquery/auth"
        let serviceName =  "/\(parameters.pushId)"
        
        let request = NotificationGetPushDetailsRequest(serviceName: serviceName,
                                                        serviceUrl: absoluteUrl,
                                                        method: .get,
                                                        headers: self.headers,
                                                        localServiceName: .notificationTokenRegister,
                                                        authorization: .oauth)
        
        
        let result: Result<PLNotificationDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
    
    func getPushDetailsBeforeLogin(pushId: Int, parameters: NotificationGetPushDetailsBeforeLoginParameters) throws -> Result<PLNotificationDTO, NetworkProviderError> {
        guard
            let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        
        let absoluteUrl = baseUrl + "/api/notification/pushquery"
        let serviceName =  "/\(pushId)"
        let request = NotificationGetPushDetailsBeforeLoginRequest(serviceName: serviceName,
                                                        serviceUrl: absoluteUrl,
                                                        method: .post,
                                                        jsonBody: parameters,
                                                        headers: headers,
                                                        localServiceName: .notificationPushDetailsBeforeLogin,
                                                        authorization: .trustedDeviceOnly)
        
        let result: Result<PLNotificationDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
    
    func getPushUnreadedCount(_ parameters: NotificationGetPushListParameters) throws -> Result<PLUnreadedPushCountDTO, NetworkProviderError> {
        guard
            let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        let absoluteUrl = baseUrl + "/api/notification/pushquery/auth"
        
        let queryParams = ["categories" : parameters.enabledPushCategories.map { $0.rawValue }.joined(separator: ",")]

        let serviceName =  NotificationsServiceType.unreadedCount.rawValue + "/\(parameters.deviceId)"
        
        let request = NotificationGetPushUnreadedCountRequest(serviceName: serviceName,
                                                              serviceUrl: absoluteUrl,
                                                              method: .get,
                                                              headers: self.headers,
                                                              queryParams: queryParams,
                                                              localServiceName: .notificationPushqueryUnreadedCount,
                                                              authorization: .oauth)
        
        let result: Result<PLUnreadedPushCountDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
    
    func getEnabledPushCategoriesByDevice(_ parameters: NotificationGetPushListParameters) throws -> Result<PLEnabledPushCategoriesDTO, NetworkProviderError> {
        guard
            let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        
        let absoluteUrl = baseUrl + "/api/notification/pushquery/auth"
        let serviceName =  NotificationsServiceType.categories.rawValue + "/\(parameters.deviceId)"
        
        let request = NotificationGetEnabledPushCategoriesByDeviceRequest(serviceName: serviceName,
                                                                          serviceUrl: absoluteUrl,
                                                                          method: .get,
                                                                          headers: self.headers,
                                                                          localServiceName: .notificationTokenRegister,
                                                                          authorization: .oauth)
        
        let result: Result<PLEnabledPushCategoriesDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
    
    func postPushStatus(_ parameters: PLPushStatusUseCaseInput) throws -> Result<PLPushStatusResponseDTO, NetworkProviderError> {
        guard
            let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        let absoluteUrl = baseUrl + "/api/notification/pushstatus/auth"
        let serviceName =  NotificationsServiceType.set.rawValue
        
        let request = NotificationPushStatusRequest(serviceName: serviceName,
                                                    serviceUrl: absoluteUrl,
                                                    method: .post,
                                                    jsonBody: parameters,
                                                    headers: self.headers,
                                                    localServiceName: .notificationTokenRegister,
                                                    authorization: .oauth)
        
        let result: Result<PLPushStatusResponseDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
    
    func postPushStatusBeforeLogin(_ parameters: PLPushStatusUseCaseInput) throws -> Result<PLPushStatusResponseDTO, NetworkProviderError> {
        guard
            let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        
        let absoluteUrl = baseUrl + "/api/notification/pushstatus"
        let serviceName =  NotificationsServiceType.set.rawValue
        
        let request = NotificationPushStatusRequest(serviceName: serviceName,
                                                        serviceUrl: absoluteUrl,
                                                        method: .post,
                                                        jsonBody: parameters,
                                                        headers: headers,
                                                        localServiceName: .notificationPushStatusBeforeLogin,
                                                        authorization: .trustedDeviceOnly)
        
        let result: Result<PLPushStatusResponseDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
    
    func postSetAllPushStatus(_ parameters: PLPushSetAllStatusUseCaseInput) throws -> Result<Void, NetworkProviderError> {
        guard
            let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        
        let absoluteUrl = baseUrl + "/api/notification/pushstatus/auth"
        let serviceName =  NotificationsServiceType.setAll.rawValue
        let request = NotificationPushSetAllStatusRequest(serviceName: serviceName,
                                                          serviceUrl: absoluteUrl,
                                                          method: .post,
                                                          jsonBody: parameters,
                                                          headers: self.headers,
                                                          localServiceName: .notificationTokenRegister,
                                                          authorization: .oauth)
        let result: Result<Void, NetworkProviderError> = self.networkProvider.request(request)
        return result
        
    }
    
    func postPushListPageSize(_ parameters: NotificationPostPushListPageSizeParameters) throws -> Result<PLNotificationListDTO, NetworkProviderError> {
        guard
            let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        
        let absoluteUrl = baseUrl + "/api/notification/pushquery"
        let serviceName =  NotificationsServiceType.list.rawValue
        
        let request = NotificationPostPushListPageSizeRequest(serviceName: serviceName,
                                                              serviceUrl: absoluteUrl,
                                                              method: .post,
                                                              jsonBody: parameters,
                                                              headers: self.headers,
                                                              localServiceName: .notificationPushqueryList,
                                                              authorization: .oauth)
        
        let result: Result<PLNotificationListDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
}
