//
//  PLDeviceDataParametersEncryptionUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 23/6/21.
//

import Commons
import DomainCommon
import PLCommons
import CryptoSwift

final class PLDeviceDataParametersEncryptionUseCase: UseCase<PLDeviceDataParametersEncryptionUseCaseInput, PLDeviceDataParametersEncryptionUseCaseOutput, PLDeviceDataUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLDeviceDataParametersEncryptionUseCaseInput) throws -> UseCaseResponse<PLDeviceDataParametersEncryptionUseCaseOutput, PLDeviceDataUseCaseErrorOutput> {

        do {
            let encryptedParameters = try self.encryptParameters(requestValues.parameters,
                                                                 with: requestValues.transportKey)
            return UseCaseResponse.ok(PLDeviceDataParametersEncryptionUseCaseOutput(encryptedParameters: encryptedParameters))
        } catch {
            return UseCaseResponse.error(PLDeviceDataUseCaseErrorOutput(error.localizedDescription))
        }
    }
}

private extension PLDeviceDataParametersEncryptionUseCase {

    enum Constants {
        // The initial vector to encrypt needs to be set to 0
        static let initialVector: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    }

    // parameters: must be an hexadecimal string of 32 characteres (16 bytes)
    // transportKey is the password the user introduced (normal or masked password)
    func encryptParameters(_ parameters: String, with transportKey: String) throws -> String {

        let parametersBytes = parameters.bytes
        let transportKeyBytes = transportKey.hexaBytes

        guard transportKeyBytes.count == 16 else { throw PLDeviceDataEncryptionError.transportKeyEncryptionError }

        // Tkey encrypted with AES128 with the TKey and initial vector to 0 (For padding is used .pkcs5 as .nopadding can´t be used due to the string length which will be different to 16 bytes length)
        guard let aes = try? AES(key: transportKeyBytes, blockMode: CBC(iv: Constants.initialVector), padding: .pkcs5),
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


private extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { startIndex in
            guard startIndex < self.endIndex else { return nil }
            let endIndex = self.index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}
