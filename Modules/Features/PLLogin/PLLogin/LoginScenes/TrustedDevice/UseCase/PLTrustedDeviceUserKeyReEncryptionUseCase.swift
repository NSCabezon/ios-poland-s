//
//  PLTrustedDeviceUserKeyReEncryptionUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 6/10/21.
//

import Commons
import PLCommons
import DomainCommon
import CryptoSwift

final class PLTrustedDeviceUserKeyReEncryptionUseCase: UseCase<PLTrustedDeviceUserKeyReEncryptionUseCaseInput, PLTrustedDeviceUserKeyReEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLTrustedDeviceUserKeyReEncryptionUseCaseInput) throws -> UseCaseResponse<PLTrustedDeviceUserKeyReEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        var reEncryptedUserKeyPIN: String = ""
        var reEncryptedUserKeyBiometrics: String?

        for token in requestValues.tokens {
            switch token.typeMapped {
            case .PIN:
                reEncryptedUserKeyPIN = try PLLoginEncryptionHelper.reEncryptUserKey(requestValues.appId,
                                                                                     pin: requestValues.pin,
                                                                                     privateKey: requestValues.privateKey,
                                                                                     encryptedUserKey: token.key)
            case .BIOMETRICS:
                reEncryptedUserKeyBiometrics = try PLLoginEncryptionHelper.reEncryptUserKey(requestValues.appId,
                                                                                            pin: nil,
                                                                                            privateKey: requestValues.privateKey,
                                                                                            encryptedUserKey: token.key)
            default:
                continue
            }
        }
        
        return .ok(PLTrustedDeviceUserKeyReEncryptionUseCaseOutput(reEncryptedUserKeyPIN: reEncryptedUserKeyPIN,
                                                                   reEncryptedUserKeyBiometrics: reEncryptedUserKeyBiometrics))
    }
}

// MARK: I/O types definition
struct PLTrustedDeviceUserKeyReEncryptionUseCaseInput {
    let appId: String
    let pin: String
    let privateKey: SecKey
    let tokens: [TrustedDeviceSoftwareToken]
}

struct PLTrustedDeviceUserKeyReEncryptionUseCaseOutput {
    let reEncryptedUserKeyPIN: String
    let reEncryptedUserKeyBiometrics: String?
}
