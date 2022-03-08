//
//  PLNotificationGetPushDetailsBeforeLoginUseCase.swift
//  PLNotificationsInbox
//
//  Created by 185860 on 02/03/2022.
//

import CoreFoundationLib
import SANPLLibrary
import PLCommons

public final class PLNotificationGetPushDetailsBeforeLoginUseCase: UseCase<GetPushDetailsBeforeLoginUseCaseInput, GetPushDetailsUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>>, PLNotificationsUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: GetPushDetailsBeforeLoginUseCaseInput) throws -> UseCaseResponse<GetPushDetailsUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let trustedDeviceId = managerProvider.getTrustedDeviceManager().getStoredTrustedDeviceInfo()?.trustedDeviceId ?? 0
        let parameters = NotificationGetPushDetailsBeforeLoginParameters(deviceId: trustedDeviceId, loginId: requestValues.loginId)
        
        let result = try managerProvider.getNotificationManager().getPushDetailsBeforeLogin(pushId: requestValues.pushId, parameters: parameters)
        switch result {
        case .success(let response):
            let output = GetPushDetailsUseCaseOkOutput(entity: PLNotificationEntity(response))
            return .ok(output)
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

// MARK: I/O types definition
public struct GetPushDetailsBeforeLoginUseCaseInput {
    let pushId: Int
    let loginId: Int
}
