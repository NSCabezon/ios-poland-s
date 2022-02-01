//
//  PLPinParametersEncryptionUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 30/6/21.
//

import CoreFoundationLib
import PLCommons
import CoreFoundationLib
import CryptoSwift
import Security
import CommonCrypto
import os
import SANPLLibrary

final class PLSoftwareTokenParametersEncryptionUseCase: UseCase<PLSoftwareTokenParametersEncryptionUseCaseInput, PLSoftwareTokenParametersEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    
    private let dependenciesResolver: DependenciesResolver
    lazy private var trustedHeadersProvider: PLTrustedHeadersGenerable = {
        dependenciesResolver.resolve(for: PLTrustedHeadersGenerable.self)
    }()
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLSoftwareTokenParametersEncryptionUseCaseInput) throws -> UseCaseResponse<PLSoftwareTokenParametersEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {

        do {
            let encryptedParameters = try trustedHeadersProvider.encryptParameters(
                requestValues.parameters,
                with: requestValues.key
            )
            return .ok(PLSoftwareTokenParametersEncryptionUseCaseOutput(encryptedParameters: encryptedParameters))
        } catch {
            return .error(PLUseCaseErrorOutput(errorDescription: error.localizedDescription))
        }
    }
}

// MARK: I/O types definition
struct PLSoftwareTokenParametersEncryptionUseCaseInput {
    let parameters: String
    let key: SecKey
}

struct PLSoftwareTokenParametersEncryptionUseCaseOutput {
    let encryptedParameters: String
}
