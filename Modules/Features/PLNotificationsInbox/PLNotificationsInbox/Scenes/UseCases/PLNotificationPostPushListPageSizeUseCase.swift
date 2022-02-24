//
//  PLNotificationPushListUseCase.swift
//  PLNotificationsInbox
//
//  Created by 188454 on 24/01/2022.
//

import CoreFoundationLib
import SANPLLibrary
import PLCommons

public final class PLNotificationPostPushListPageSizeUseCase: UseCase<PLPostPushListPageSizeUseCaseInput, PostPushListPageSizeUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>>, PLNotificationsUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLPostPushListPageSizeUseCaseInput) throws -> UseCaseResponse<PostPushListPageSizeUseCaseOkOutput, PLUseCaseErrorOutput<NotificationsErrorType>> {
        let globalPosition: GlobalPositionRepresentable = dependenciesResolver.resolve(for: GlobalPositionRepresentable.self)
        guard let userId: Int = Int(globalPosition.userId ?? "") else { fatalError() }
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        
        let parameters = NotificationPostPushListPageSizeParameters(
            loginId: userId,
            deviceId: managerProvider.getTrustedDeviceManager().getStoredTrustedDeviceInfo()?.trustedDeviceId ?? 0,
            categories: requestValues.categories,
            statuses: requestValues.statuses,
            pushId: requestValues.pushId,
            pageSize: requestValues.pageSize
        )
        let result = try managerProvider.getNotificationManager().postPushListPageSize(parameters)
        switch result {
        case .success(let response):
            let output = PostPushListPageSizeUseCaseOkOutput(entity: PLNotificationListEntity(response))
            return .ok(output)
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

public struct PLPostPushListPageSizeUseCaseInput: Codable {
    public let categories: [EnabledPushCategorie]
    public let statuses: [NotificationStatus]
    public let pushId: Int?
    public var pageSize: Int = 25

    public init(categories: [EnabledPushCategorie], statuses: [NotificationStatus], pushId: Int?) {
        self.categories = categories
        self.statuses = statuses
        self.pushId = pushId
    }
}

public struct PostPushListPageSizeUseCaseOkOutput {
    public let entity: PLNotificationListEntity
}
