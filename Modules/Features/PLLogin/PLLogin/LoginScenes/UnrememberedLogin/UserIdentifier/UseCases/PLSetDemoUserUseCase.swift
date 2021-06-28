//
//  PLSetDemoUserUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 25/6/21.
//

import Commons
import DomainCommon
import SANPLLibrary

final class PLSetDemoUserUseCase: UseCase<PLSetDemoUserUseCaseInput, PLSetDemoUserUseCaseOkOutput, PLSetDemoUserUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLSetDemoUserUseCaseInput) throws -> UseCaseResponse<PLSetDemoUserUseCaseOkOutput, PLSetDemoUserUseCaseErrorOutput> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let isDemoUser = managerProvider.getLoginManager().setDemoModeIfNeeded(for: requestValues.userId)
        return UseCaseResponse.ok(PLSetDemoUserUseCaseOkOutput(isDemoUser: isDemoUser))
    }
}

// MARK: I/O types definition
final class PLSetDemoUserUseCaseErrorOutput: StringErrorOutput {}

public struct PLSetDemoUserUseCaseInput {
    let userId: String
}

public struct PLSetDemoUserUseCaseOkOutput {
    let isDemoUser: Bool
}
