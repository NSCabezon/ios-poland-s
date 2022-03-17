//
//  PLNotificationManager.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 24/9/21.
//

import Foundation

public protocol PLNotificationManagerProtocol {
    func doRegisterToken(_ parameters: NotificationRegisterParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
    func getPushList(_ parameters: NotificationGetPushListParameters) throws -> Result<PLNotificationListDTO, NetworkProviderError>
    func getPushDetails(_ parameters: NotificationGetPushDetailsParameters) throws -> Result<PLNotificationDTO, NetworkProviderError>
    func getPushDetailsBeforeLogin(pushId: Int, parameters: NotificationGetPushDetailsBeforeLoginParameters) throws -> Result<PLNotificationDTO, NetworkProviderError>
    func getPushUnreadedCount(_ parameters: NotificationGetPushListParameters) throws -> Result<PLUnreadedPushCountDTO, NetworkProviderError>
    func getEnabledPushCategoriesByDevice(_ parameters: NotificationGetPushListParameters) throws -> Result<PLEnabledPushCategoriesDTO, NetworkProviderError>
    func postPushStatus(_ parameters: PLPushStatusUseCaseInput) throws -> Result<PLPushStatusResponseDTO, NetworkProviderError>
    func postPushStatusBeforeLogin(_ parameters: PLPushStatusUseCaseInput) throws -> Result<PLPushStatusResponseDTO, NetworkProviderError>
    func postPushListPageSize(_ parameters: NotificationPostPushListPageSizeParameters) throws -> Result<PLNotificationListDTO, NetworkProviderError>
    func postPostSetAllPushStatus(_ parameters: PLPushSetAllStatusUseCaseInput) throws -> Result<Void, NetworkProviderError>
}

public final class PLNotificationManager {
    private let notificationDataSource: NotificationDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.notificationDataSource = NotificationDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLNotificationManager: PLNotificationManagerProtocol {
    public func doRegisterToken(_ parameters: NotificationRegisterParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        let result = try notificationDataSource.doRegisterToken(parameters)
        return result
    }
    
    public func getPushList(_ parameters: NotificationGetPushListParameters) throws -> Result<PLNotificationListDTO, NetworkProviderError> {
        let result = try notificationDataSource.getPushList(parameters)
        return result
    }
    
    public func getPushDetails(_ parameters: NotificationGetPushDetailsParameters) throws -> Result<PLNotificationDTO, NetworkProviderError> {
        let result = try notificationDataSource.getPushDetails(parameters)
        return result
    }
    
    public func getPushDetailsBeforeLogin(pushId: Int, parameters: NotificationGetPushDetailsBeforeLoginParameters) throws -> Result<PLNotificationDTO, NetworkProviderError> {
        let result = try notificationDataSource.getPushDetailsBeforeLogin(pushId: pushId, parameters: parameters)
        return result
    }
    
    public func getPushUnreadedCount(_ parameters: NotificationGetPushListParameters) throws -> Result<PLUnreadedPushCountDTO, NetworkProviderError> {
        let result = try notificationDataSource.getPushUnreadedCount(parameters)
        return result
    }
    
    public func getEnabledPushCategoriesByDevice(_ parameters: NotificationGetPushListParameters) throws -> Result<PLEnabledPushCategoriesDTO, NetworkProviderError> {
        let result = try notificationDataSource.getEnabledPushCategoriesByDevice(parameters)
        return result
    }
    
    public func postPushStatus(_ parameters: PLPushStatusUseCaseInput) throws -> Result<PLPushStatusResponseDTO, NetworkProviderError> {
        let result = try notificationDataSource.postPushStatus(parameters)
        return result
    }
    
    public func postPushStatusBeforeLogin(_ parameters: PLPushStatusUseCaseInput) throws -> Result<PLPushStatusResponseDTO, NetworkProviderError> {
        let result = try notificationDataSource.postPushStatusBeforeLogin(parameters)
        return result
    }
    
    public func postPushListPageSize(_ parameters: NotificationPostPushListPageSizeParameters) throws -> Result<PLNotificationListDTO, NetworkProviderError> {
        let result = try notificationDataSource.postPushListPageSize(parameters)
        return result
    }
    
    public func postPostSetAllPushStatus(_ parameters: PLPushSetAllStatusUseCaseInput) throws -> Result<Void, NetworkProviderError> {
        let result = try notificationDataSource.postSetAllPushStatus(parameters)
        return result
    }
}
