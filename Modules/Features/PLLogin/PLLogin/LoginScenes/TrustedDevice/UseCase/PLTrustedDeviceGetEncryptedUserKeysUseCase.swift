//
//  PLTrustedDeviceGetStoredEncryptedUserKeyUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 20/10/21.
//

import Commons
import PLCommons
import DomainCommon
import CryptoSwift
import SANPLLibrary

public final class PLTrustedDeviceGetStoredEncryptedUserKeyUseCase: UseCase<Void, PLTrustedDeviceGetStoredEncryptedUserKeyUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLTrustedDeviceGetStoredEncryptedUserKeyUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()
        guard let encryptedUserKeys = trustedDeviceManager.getEncryptedUserKeys() else { return .error(PLUseCaseErrorOutput(errorDescription: "Keys not available")) }
        let output = PLTrustedDeviceGetStoredEncryptedUserKeyUseCaseOutput(encryptedUserKeyPIN: encryptedUserKeys.pinUserKey,
                                                                           encryptedUserKeyBiometrics: encryptedUserKeys.biometricUserKey)

        return .ok(output)
    }
}

// MARK: I/O types definition
public struct PLTrustedDeviceGetStoredEncryptedUserKeyUseCaseOutput {
    public let encryptedUserKeyPIN: String
    public let encryptedUserKeyBiometrics: String?
    
    public init(encryptedUserKeyPIN: String, encryptedUserKeyBiometrics: String?) {
        self.encryptedUserKeyPIN = encryptedUserKeyPIN
        self.encryptedUserKeyBiometrics = encryptedUserKeyBiometrics
    }
}
