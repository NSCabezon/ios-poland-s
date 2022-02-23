//
//  PLNotificationGetPushListUseCase.swift
//  Pods
//
//  Created by 185860 on 12/01/2022.
//

import CoreFoundationLib
import SANPLLibrary
import PLCommons

public final class PLNotificationGetPushListUseCase: UseCase<Void, GetPushListUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>>, PLNotificationsUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetPushListUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let deviceID = managerProvider.getTrustedDeviceManager().getStoredTrustedDeviceInfo()?.trustedDeviceId ?? 0
        let parameters = NotificationGetPushListParameters(deviceId: deviceID)
        let result = try managerProvider.getNotificationManager().getPushList(parameters)
        switch result {
        case .success(let response):
            let output = GetPushListUseCaseOkOutput(entity: PLNotificationListEntity(response))
            return .ok(output)
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

public struct GetPushListUseCaseOkOutput {
    public let entity: PLNotificationListEntity
}
