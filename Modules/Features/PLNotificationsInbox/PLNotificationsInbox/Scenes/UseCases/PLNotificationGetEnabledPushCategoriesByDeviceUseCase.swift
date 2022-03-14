//
//  PLNotificationGetEnabledPushCategoriesByDeviceUseCase.swift
//  Pods
//
//  Created by 185860 on 12/01/2022.
//

import CoreFoundationLib
import SANPLLibrary
import PLCommons

public final class PLNotificationGetEnabledPushCategoriesByDeviceUseCase: UseCase<Void, GetEnabledPushCategoriesByDeviceUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>>, PLNotificationsUseCaseErrorHandlerProtocol {
  
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetEnabledPushCategoriesByDeviceUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let deviceID = managerProvider.getTrustedDeviceManager().getStoredTrustedDeviceInfo()?.trustedDeviceId ?? 0
        let parameters = NotificationGetPushListParameters(deviceId: deviceID)
        let result = try managerProvider.getNotificationManager().getEnabledPushCategoriesByDevice(parameters)
        switch result {
        case .success(let response):
            let output = GetEnabledPushCategoriesByDeviceUseCaseOkOutput(entity: PLEnabledPushCategoriesListEntity(response))
            return .ok(output)
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

public struct GetEnabledPushCategoriesByDeviceUseCaseOkOutput {
    public let entity: PLEnabledPushCategoriesListEntity
}
