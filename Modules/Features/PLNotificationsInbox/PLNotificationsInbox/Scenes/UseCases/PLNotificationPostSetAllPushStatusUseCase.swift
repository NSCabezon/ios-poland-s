//
//  PLNotificationPostSetAllPushStatusUseCase.swift
//  PLNotificationsInbox
//
//  Created by 185860 on 25/01/2022.
//

import CoreFoundationLib
import SANPLLibrary
import PLCommons

public final class PLNotificationPostSetAllPushStatusUseCase: UseCase<Void, Void, PLUseCaseErrorOutput<NotificationsErrorType>>, PLNotificationsUseCaseErrorHandlerProtocol {
    
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<NotificationsErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let deviceID = managerProvider.getTrustedDeviceManager().getStoredTrustedDeviceInfo()?.trustedDeviceId ?? 0
        let input = PLPushSetAllStatusUseCaseInput(deviceId: deviceID, categories: [])
        let result = try managerProvider.getNotificationManager().postPostSetAllPushStatus(input)
        switch result {
        case .success(_ ):
            return .ok()
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }    
}
