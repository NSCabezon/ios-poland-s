//
//  PLSetDemoUserUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 25/6/21.
//

import CoreFoundationLib
import CoreFoundationLib
import PLCommons
import SANPLLibrary

final class PLSetDemoUserUseCase: UseCase<PLSetDemoUserUseCaseInput, PLSetDemoUserUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLSetDemoUserUseCaseInput) throws -> UseCaseResponse<PLSetDemoUserUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let isDemoUser = managerProvider.getLoginManager().setDemoModeIfNeeded(for: requestValues.userId)
        return UseCaseResponse.ok(PLSetDemoUserUseCaseOkOutput(isDemoUser: isDemoUser, userId: requestValues.userId))
    }
}

public struct PLSetDemoUserUseCaseInput {
    let userId: String
}

public struct PLSetDemoUserUseCaseOkOutput {
    let isDemoUser: Bool
    let userId: String
}
