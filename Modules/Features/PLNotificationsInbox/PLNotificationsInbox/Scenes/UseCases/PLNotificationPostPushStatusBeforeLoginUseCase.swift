//
//  PLNotificationPostPushStatusBeforeLoginUseCase.swift
//  PLNotificationsInbox
//
//  Created by 185860 on 02/03/2022.
//

import CoreFoundationLib
import SANPLLibrary
import PLCommons

public final class PLNotificationPostPushStatusBeforeLoginUseCase: UseCase<NotificationPostPushStatusInput, PostPushStatusUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>>, PLNotificationsUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: NotificationPostPushStatusInput) throws -> UseCaseResponse<PostPushStatusUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        
        let result = try managerProvider.getNotificationManager().postPushStatusBeforeLogin(requestValues.pushStatus)
        switch result {
        case .success(let response):
            let output = PostPushStatusUseCaseOkOutput(entity: PLPushStatusResponseEntity(response))
            return .ok(output)
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

