//
//  PLNotificationGetUnreadedPushCountUseCase.swift
//  PLLogin
//
//  Created by 185860 on 12/01/2022.
//

import CoreFoundationLib
import SANPLLibrary
import PLCommons

public final class PLNotificationGetUnreadedPushCountUseCase: UseCase<GetUnreadedPushCountUseCaseInput, GetUnreadedPushCountUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>>, PLNotificationsUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: GetUnreadedPushCountUseCaseInput) throws -> UseCaseResponse<GetUnreadedPushCountUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let deviceID = managerProvider.getTrustedDeviceManager().getStoredTrustedDeviceInfo()?.trustedDeviceId ?? 0
        let parameters = NotificationGetPushListParameters(deviceId: deviceID, enabledPushCategories: requestValues.enabledPushCategories)

        let result = try managerProvider.getNotificationManager().getPushUnreadedCount(parameters)
        switch result {
        case .success(let response):
            let output = GetUnreadedPushCountUseCaseOkOutput(entity: PLUnreadedPushCountEntity(response))
            return .ok(output)
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

public struct GetUnreadedPushCountUseCaseInput {
    public let enabledPushCategories: [EnabledPushCategorie]
}

public struct GetUnreadedPushCountUseCaseOkOutput {
    public let entity: PLUnreadedPushCountEntity
}
