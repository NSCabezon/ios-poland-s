//
//  PLDeviceDataParametersEncryptionUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 23/6/21.
//

import Commons
import PLCommons
import DomainCommon
import CryptoSwift

final class PLDeviceDataParametersEncryptionUseCase: UseCase<PLDeviceDataParametersEncryptionUseCaseInput, PLDeviceDataParametersEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLDeviceDataParametersEncryptionUseCaseInput) throws -> UseCaseResponse<PLDeviceDataParametersEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {

        do {
            let encryptedParameters = try self.encryptParameters(requestValues.parameters,
                                                                 with: requestValues.transportKey)
            return .ok(PLDeviceDataParametersEncryptionUseCaseOutput(encryptedParameters: encryptedParameters))
        } catch {
            return .error(PLUseCaseErrorOutput(errorDescription: error.localizedDescription))
        }
    }
}

private extension PLDeviceDataParametersEncryptionUseCase {

    enum Constants {
        static let initialVector: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    }

    // parameters: string with parameters to encrypt (i.e. "<2021-04-18 22:01:11.238><AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><Apple><model><iPhone 12>")
    // transportKey is the secure random transportKey that will be used to encrypt parameters. Must be an hexadecimal string of 32 characteres (16 bytes)
    func encryptParameters(_ parameters: String, with transportKey: String) throws -> String {
        let transportKeyBytes = transportKey.hexaBytes
        guard transportKeyBytes.count == 16 else { throw PLDeviceDataEncryptionError.transportKeyEncryptionError }

        // Number of characters must be multiple of 16 so we need to add spaces at the end of the parameters (It is necessary so we will encrypt it with .noPadding)
        let parametersWithSpaces = PLLoginTrustedDeviceHelpers.stringMultipleOf16(parameters)
        let parametersBytes = parametersWithSpaces.bytes
        guard parametersBytes.count%16 == 0 else { throw PLDeviceDataEncryptionError.transportKeyEncryptionError }

        // AES/CBC/NoPadding encryption
        guard let aes = try? AES(key: transportKeyBytes, blockMode: CBC(iv: Constants.initialVector), padding: .noPadding),
              let encryptedParametersBytes = try? aes.encrypt(parametersBytes) else {
            throw PLDeviceDataEncryptionError.parametersEncryptionError
        }

        return encryptedParametersBytes.toBase64() ?? ""
    }
}

// MARK: I/O types definition
struct PLDeviceDataParametersEncryptionUseCaseInput {
    let parameters: String
    let transportKey: String
}

struct PLDeviceDataParametersEncryptionUseCaseOutput {
    let encryptedParameters: String
}
