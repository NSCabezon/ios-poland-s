//
//  PLTrustedDeviceStoreEncryptedUserKeyUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 19/10/21.
//

import Commons
import PLCommons
import DomainCommon
import CryptoSwift
import SANPLLibrary

final class PLTrustedDeviceStoreEncryptedUserKeyUseCase: UseCase<PLTrustedDeviceStoreEncryptedUserKeyUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLTrustedDeviceStoreEncryptedUserKeyUseCaseInput) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()
        let encryptedKeys = EncryptedUserKeys(pinUserKey: requestValues.encryptedUserKeyPIN,
                                              biometricUserKey: requestValues.encryptedUserKeyBiometrics)
        trustedDeviceManager.storeEncryptedUserKeys(encryptedKeys)

        return .ok()
    }
}

// MARK: I/O types definition
struct PLTrustedDeviceStoreEncryptedUserKeyUseCaseInput {
    let encryptedUserKeyPIN: String
    let encryptedUserKeyBiometrics: String?
}
