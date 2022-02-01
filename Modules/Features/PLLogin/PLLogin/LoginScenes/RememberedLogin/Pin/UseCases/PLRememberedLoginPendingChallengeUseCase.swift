//
//  PLRememberedLoginPendingChallengeUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 20/10/21.
//

import CoreFoundationLib
import PLCommons
import CoreFoundationLib
import SANPLLibrary

final class PLRememberedLoginPendingChallengeUseCase: UseCase<PLRememberedLoginPendingChallengeUseCaseInput, PLRememberedLoginPendingChallenge, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public override func executeUseCase(requestValues: PLRememberedLoginPendingChallengeUseCaseInput) throws -> UseCaseResponse<PLRememberedLoginPendingChallenge, PLUseCaseErrorOutput<LoginErrorType>> {
        
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        
        let parameters = PendingChallengeParameters(userId: requestValues.userId)
        let result = try managerProvider.getTrustedDeviceManager().getPendingChallenge(parameters)
        switch result {
        case .success(let result):
            let response = PLRememberedLoginPendingChallenge(dto: result)
            return UseCaseResponse.ok(response)
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

struct PLRememberedLoginPendingChallengeUseCaseInput {
    let userId: String
}

public struct PLRememberedLoginPendingChallenge {
    public let authorizationId: Int?
    public let description: String?
    public let challenge: String
    public let expirationTime: String
    public let pendingChallengeOrigin: String
    public let softwareTokenKeys: [PLRememberedLoginSoftwareTokenKeys]
    
    init(dto: PendingChallengeDTO) {
        self.authorizationId = dto.authorizationId
        self.description = dto.description
        self.challenge = dto.challenge
        self.expirationTime = dto.expirationTime
        self.pendingChallengeOrigin = dto.pendingChallengeOrigin
        self.softwareTokenKeys = dto.softwareTokenKeys.map { token in
            return PLRememberedLoginSoftwareTokenKeys(dto: token)
        }
    }

    public func getSoftwareTokenKey(for softwareTokenType: SoftwareTokenType) -> PLRememberedLoginSoftwareTokenKeys? {
        return self.softwareTokenKeys.first { token in
            token.typeMapped == softwareTokenType }
    }
}

public struct PLRememberedLoginSoftwareTokenKeys {
    public let randomKey: String
    public let name: String
    public let softwareTokenType: String
    
    init(dto: SoftwareTokenKeysDataDTO) {
        self.randomKey = dto.randomKey
        self.name = dto.name
        self.softwareTokenType = dto.softwareTokenType
    }
    
    var typeMapped: SoftwareTokenType {
        switch self.softwareTokenType.uppercased() {
        case "PIN":
            return .PIN
        case "BIOMETRICS":
            return .BIOMETRICS
        default:
            return .UNKNOWN
        }
    }
}
