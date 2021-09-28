//
//  PLNotificationManager.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 24/9/21.
//

import Foundation

public protocol PLNotificationManagerProtocol {
    func doRegisterToken(_ parameters: NotificationRegisterParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
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
}
