//
//  PLDeviceDataTransportKeyEncryptionUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 23/6/21.
//

import Commons
import DomainCommon
import CryptoSwift

final class PLDeviceDataTransportKeyEncryptionUseCase: UseCase<PLDeviceDataTransportKeyEncryptionUseCaseInput, PLDeviceDataTransportKeyEncryptionUseCaseOutput, PLDeviceDataUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLDeviceDataTransportKeyEncryptionUseCaseInput) throws -> UseCaseResponse<PLDeviceDataTransportKeyEncryptionUseCaseOutput, PLDeviceDataUseCaseErrorOutput> {

        do {
            let encryptedTransportKey = try self.encryptTransportKey(requestValues.transportKey,
                                                                     with: requestValues.passKey)
            return UseCaseResponse.ok(PLDeviceDataTransportKeyEncryptionUseCaseOutput(encryptedTransportKey: encryptedTransportKey))
        } catch {
            return UseCaseResponse.error(PLDeviceDataUseCaseErrorOutput(error.localizedDescription))
        }
    }
}

private extension PLDeviceDataTransportKeyEncryptionUseCase {

    enum Constants {
        // The initial vector to encrypt needs to be set to 0
        static let initialVector: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    }

    // transportKey: must be an hexadecimal string of 32 characteres (16 bytes)
    // passKey: is the password user introduced (normal or masked password)
    func encryptTransportKey(_ transportKey: String, with passKey: String) throws -> String {

        let transportKeyBytes = transportKey.hexaBytes

        guard transportKeyBytes.count == 16 else { throw PLDeviceDataEncryptionError.transportKeyEncryptionError }

        let passKeyLength16 = PLLoginTrustedDeviceHelpers.length16Password(passKey)
        // Length 16 password bytes
        let passKeyLength16Bytes = passKeyLength16?.bytes

        // Tkey encrypted with AES128 with the PassKey and initial vector to 0
        guard let aes = try? AES(key: passKeyLength16Bytes!, blockMode: CBC(iv: Constants.initialVector), padding: .noPadding),
              let encryptedTransportKey = try? aes.encrypt(transportKeyBytes) else {
            throw PLDeviceDataEncryptionError.transportKeyEncryptionError
        }

        let encryptedTransportKeyBase64 = encryptedTransportKey.toBase64()
        return encryptedTransportKeyBase64 ?? ""
    }
}

// MARK: I/O types definition
struct PLDeviceDataTransportKeyEncryptionUseCaseInput {
    let transportKey: String
    let passKey: String
}

struct PLDeviceDataTransportKeyEncryptionUseCaseOutput {
    let encryptedTransportKey: String
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
