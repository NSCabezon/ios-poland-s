//
//  PLAuthorizationDataEncryptionUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 20/10/21.
//

import CoreFoundationLib
import CryptoSwift

public final class PLAuthorizationDataEncryptionUseCase<Error>: UseCase<PLAuthorizationDataEncryptionUseCaseInput, PLAuthorizationDataEncryptionUseCaseOutput, PLUseCaseErrorOutput<Error>>{
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLAuthorizationDataEncryptionUseCaseInput) throws -> UseCaseResponse<PLAuthorizationDataEncryptionUseCaseOutput, PLUseCaseErrorOutput<Error>> {
        
        guard requestValues.isDemoUser == false else {
            return .ok(PLAuthorizationDataEncryptionUseCaseOutput(encryptedAuthorizationData: "demoUser"))
        }

        do {
            let randomKeyDecryptedBase64 = try PLEncryptionHelper.getRandomKeyFromSoftwareToken(appId: requestValues.appId,
                                                                                                     pin: requestValues.pin,
                                                                                                     encryptedUserKey: requestValues.encryptedUserKey,
                                                                                                     randomKey: requestValues.randomKey)
            let encryptedData = try PLEncryptionHelper.calculateAuthorizationData(randomKey: randomKeyDecryptedBase64,
                                                                                       challenge: requestValues.challenge,
                                                                                       privateKey: requestValues.privateKey)
            return .ok(PLAuthorizationDataEncryptionUseCaseOutput(encryptedAuthorizationData: encryptedData))
        } catch {
            return .error(PLUseCaseErrorOutput(errorDescription: error.localizedDescription))
        }
    }
}

// MARK: I/O types definition
public struct PLAuthorizationDataEncryptionUseCaseInput {
    public let isDemoUser: Bool
    public let appId: String
    public let pin: String?
    public let encryptedUserKey: String
    public let randomKey: String
    public let challenge: String
    public let privateKey: SecKey
    
    public init(appId: String, pin: String?, encryptedUserKey: String, randomKey: String, challenge: String, privateKey: SecKey, isDemoUser: Bool = false) {
        self.appId = appId
        self.pin = pin
        self.encryptedUserKey = encryptedUserKey
        self.randomKey = randomKey
        self.challenge = challenge
        self.privateKey = privateKey
        self.isDemoUser = isDemoUser
    }
}

public struct PLAuthorizationDataEncryptionUseCaseOutput {
    public let encryptedAuthorizationData: String
    
    public init (encryptedAuthorizationData: String) {
        self.encryptedAuthorizationData = encryptedAuthorizationData
    }
}
