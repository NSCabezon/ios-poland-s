//
//  PLNotificationGetPushDetailsUseCase.swift
//  PLLogin
//
//  Created by 185860 on 12/01/2022.
//

import CoreFoundationLib
import SANPLLibrary
import PLCommons

public final class PLNotificationGetPushDetailsUseCase: UseCase<GetPushDetailsUseCaseInput, GetPushDetailsUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>>, PLNotificationsUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: GetPushDetailsUseCaseInput) throws -> UseCaseResponse<GetPushDetailsUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = NotificationGetPushDetailsParameters(pushId: requestValues.pushId)
        let result = try managerProvider.getNotificationManager().getPushDetails(parameters)
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
public struct GetPushDetailsUseCaseInput {
    let pushId: Int
}

public struct GetPushDetailsUseCaseOkOutput {
    public let entity: PLNotificationEntity
}
