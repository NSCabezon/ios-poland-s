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

final class PLLoginAuthorizationDataEncryptionUseCase: UseCase<PLLoginAuthorizationDataEncryptionUseCaseInput, PLLoginAuthorizationDataEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
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
struct PLLoginAuthorizationDataEncryptionUseCaseInput {
    let appId: String
    let pin: String?
    let encryptedUserKey: String
    let randomKey: String
    let challenge: String
    let privateKey: SecKey
}

struct PLLoginAuthorizationDataEncryptionUseCaseOutput {
    let encryptedAuthorizationData: String
}
