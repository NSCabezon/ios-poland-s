//
//  PLLoginAuthorizationDataEncryptionUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 20/10/21.
//

import Commons
import PLCommons
import DomainCommon
import CryptoSwift

public final class PLLoginAuthorizationDataEncryptionUseCase: UseCase<PLLoginAuthorizationDataEncryptionUseCaseInput, PLLoginAuthorizationDataEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLLoginAuthorizationDataEncryptionUseCaseInput) throws -> UseCaseResponse<PLLoginAuthorizationDataEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {

        do {
            let randomKeyDecryptedBase64 = try PLLoginEncryptionHelper.getRandomKeyFromSoftwareToken(appId: requestValues.appId,
                                                                                                     pin: requestValues.pin,
                                                                                                     encryptedUserKey: requestValues.encryptedUserKey,
                                                                                                     randomKey: requestValues.randomKey)
            let encryptedData = try PLLoginEncryptionHelper.calculateAuthorizationData(randomKey: randomKeyDecryptedBase64,
                                                                                       challenge: requestValues.challenge,
                                                                                       privateKey: requestValues.privateKey)
            return .ok(PLLoginAuthorizationDataEncryptionUseCaseOutput(encryptedAuthorizationData: encryptedData))
        } catch {
            return .error(PLUseCaseErrorOutput(errorDescription: error.localizedDescription))
        }
    }
}

// MARK: I/O types definition
public struct PLLoginAuthorizationDataEncryptionUseCaseInput {
    public let appId: String
    public let pin: String?
    public let encryptedUserKey: String
    public let randomKey: String
    public let challenge: String
    public let privateKey: SecKey
    
    public init(appId: String, pin: String?, encryptedUserKey: String, randomKey: String, challenge: String, privateKey: SecKey) {
        self.appId = appId
        self.pin = pin
        self.encryptedUserKey = encryptedUserKey
        self.randomKey = randomKey
        self.challenge = challenge
        self.privateKey = privateKey
    }
}

public struct PLLoginAuthorizationDataEncryptionUseCaseOutput {
    public let encryptedAuthorizationData: String
    
    public init (encryptedAuthorizationData: String) {
        self.encryptedAuthorizationData = encryptedAuthorizationData
    }
}
