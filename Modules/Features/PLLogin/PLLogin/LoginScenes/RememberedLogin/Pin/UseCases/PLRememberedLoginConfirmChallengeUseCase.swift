//
//  PLRememberedLoginConfirmChallengeUseCase.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 20/10/21.
//

import Commons
import PLCommons
import DomainCommon
import SANPLLibrary

public final class PLRememberedLoginConfirmChallengeUseCase: UseCase<PLRememberedLoginConfirmChallengeUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
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

public struct PLRememberedLoginConfirmChallengeUseCaseInput {
    public let userId: String
    public let authorizationId: String?
    public let softwareTokenType, trustedDeviceCertificate, authorizationData: String
    
    public init (userId: String, authorizationId: String?, softwareTokenType: String, trustedDeviceCertificate: String, authorizationData: String) {
        self.userId = userId
        self.authorizationId = authorizationId
        self.softwareTokenType = softwareTokenType
        self.trustedDeviceCertificate = trustedDeviceCertificate
        self.authorizationData = authorizationData
    }
}
