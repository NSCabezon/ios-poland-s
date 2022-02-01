//
//  PLAuthenticateInitUseCase.swift
//  Account
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import CoreFoundationLib
import PLCommons
import CoreFoundationLib
import SANPLLibrary
import PLCommons

final class PLAuthenticateInitUseCase: UseCase<PLAuthenticateInitUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLAuthenticateInitUseCaseInput) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = AuthenticateInitParameters(userId: requestValues.userId, secondFactorData: SecondFactorData(defaultChallenge: DefaultChallenge(authorizationType: requestValues.challenge.authorizationType, value: requestValues.challenge.value)))
        let result = try managerProvider.getLoginManager().doAuthenticateInit(parameters)
        switch result {
        case .success(_):
            return UseCaseResponse.ok()
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

private extension PLAuthenticateInitUseCase {
    func getEnvironment() -> BSANPLEnvironmentDTO? {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let result = managerProvider.getEnvironmentsManager().getCurrentEnvironment()
        switch result {
        case .success(let dto):
            return dto
        case .failure:
            return nil
        }
    }
}

extension PLAuthenticateInitUseCase: Cancelable {
    public func cancel() {}
}

// MARK: I/O types definition
struct PLAuthenticateInitUseCaseInput {
    let userId: String
    let challenge: ChallengeEntity
}
