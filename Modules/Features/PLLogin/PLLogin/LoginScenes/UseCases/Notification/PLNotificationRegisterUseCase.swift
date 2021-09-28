//
//  PLNotificationRegisterUseCase.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 24/9/21.
//

import Commons
import PLCommons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons

public final class PLNotificationRegisterUseCase: UseCase<PLNotificationRegisterUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLNotificationRegisterUseCaseInput) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = NotificationRegisterParameters(notificationToken: requestValues.notificationToken)
        let result = try managerProvider.getNotificationManager().doRegisterToken(parameters)
        switch result {
        case .success(_):
            return UseCaseResponse.ok()
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

// MARK: I/O types definition
public struct PLNotificationRegisterUseCaseInput {
    let notificationToken: String
}
