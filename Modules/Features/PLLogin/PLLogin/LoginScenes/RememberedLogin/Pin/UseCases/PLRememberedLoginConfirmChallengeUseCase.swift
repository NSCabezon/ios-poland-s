//
//  PLRememberedLoginConfirmChallengeUseCase.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 20/10/21.
//

import CoreFoundationLib
import PLCommons
import CoreFoundationLib
import SANPLLibrary

final class PLRememberedLoginConfirmChallengeUseCase: UseCase<PLRememberedLoginConfirmChallengeUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public override func executeUseCase(requestValues: PLRememberedLoginConfirmChallengeUseCaseInput) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
                
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        guard let trustedDeviceId = managerProvider.getTrustedDeviceManager().getStoredTrustedDeviceInfo()?.trustedDeviceId else {
            return .error(PLUseCaseErrorOutput(errorDescription: "Missing trustedDeviceId"))
        }

        let parameters = ConfirmChallengeParameters(userId: requestValues.userId,
                                                    trustedDeviceId: trustedDeviceId,
                                                    softwareTokenType: requestValues.softwareTokenType,
                                                    trustedDeviceCertificate: requestValues.trustedDeviceCertificate,
                                                    authorizationData: requestValues.authorizationData)
        
        let result = try managerProvider.getTrustedDeviceManager().doConfirmChallenge(parameters)
        switch result {
        case .success(_):
            return UseCaseResponse.ok()
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

struct PLRememberedLoginConfirmChallengeUseCaseInput {
    let userId: String
    let authorizationId: String?
    let softwareTokenType, trustedDeviceCertificate, authorizationData: String
}
