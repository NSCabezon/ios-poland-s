//
//  AuthorizationModuleGetPendingChallengeUseCase.swift
//  Authorization
//
//  Created by 186484 on 05/05/2022.
//

import CoreFoundationLib
import PLCommons
import PLCommonOperatives
import SANPLLibrary
import CoreDomain


final class AuthorizationGetPendingChallengeUseCase: UseCase<AuthorizationGetPendingChallengeUseCaseInput, ChallengeRepresentable, PLUseCaseErrorOutput<StringErrorOutput>> {

    private var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: AuthorizationGetPendingChallengeUseCaseInput) throws -> UseCaseResponse<ChallengeRepresentable, PLUseCaseErrorOutput<StringErrorOutput>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = PendingChallengeParameters(userId: requestValues.userId)
        let result = try managerProvider.getTrustedDeviceManager().getPendingChallenge(parameters)
        switch result {
        case .success(let result):
            return UseCaseResponse.ok(result)
        case .failure(let error):
            return .error(PLUseCaseErrorOutput(errorDescription: error.localizedDescription))
        }
    }
}

struct AuthorizationGetPendingChallengeUseCaseInput {
    let userId: String?
}


