//
//  PLPasswordEncryptionUseCase.swift
//  PLLogin

import Commons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons
import Security
import CryptoSwift

/**
    This use case encrypt a password plain text using a public key and returns a encrypted string
 */
protocol PLPasswordEncryptionUseCaseProtocol: UseCase<PLPasswordEncryptionUseCaseInput, PLPasswordEncryptionUseCaseOutput, PLAuthenticateUseCaseErrorOutput> {}

final class PLPasswordEncryptionUseCase: UseCase<PLPasswordEncryptionUseCaseInput, PLPasswordEncryptionUseCaseOutput, PLAuthenticateUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLPasswordEncryptionUseCaseInput) throws -> UseCaseResponse<PLPasswordEncryptionUseCaseOutput, PLAuthenticateUseCaseErrorOutput> {
        do {
            let encryptedPassword = try self.encryptPassword(password: requestValues.plainPassword, encryptionKey: requestValues.encryptionKey)
            return UseCaseResponse.ok(PLPasswordEncryptionUseCaseOutput(encryptedPassword: encryptedPassword))
        } catch {
            return UseCaseResponse.error(PLAuthenticateUseCaseErrorOutput(error.localizedDescription))
        }
    }
}

private extension PLPasswordEncryptionUseCase {

    func encryptPassword(password: String, encryptionKey: EncryptionKeyEntity) throws -> String {
        guard let secPublicKey = self.getPublicKeySecurityRepresentation(encryptionKey.modulus, exponentStr: encryptionKey.exponent) else {
            throw EncryptionError.publicKeyGenerationFailed
        }
        if let encryptedBase64String = self.encrypt(string: password, publicKey: secPublicKey) {
            return encryptedBase64String
        }
        throw EncryptionError.publicKeyGenerationFailed
    }

    /// Process modulus and exponent to generate an Apple Security SecKey
    func getPublicKeySecurityRepresentation(_ modulusStr: String, exponentStr: String) -> SecKey? {
        var modulus = self.getByteArrayFromHex(inputString: modulusStr)
        let exponent = self.getByteArray(inputString: exponentStr)

        modulus.insert(0x00, at: 0)

        // encode the modulus and exponent as INTEGERs
        var modulusEncoded: [UInt8] = [0x02]
        modulusEncoded.append(contentsOf: lengthField(of: modulus))
        modulusEncoded.append(contentsOf: modulus)

        var exponentEncoded: [UInt8] = [0x02]
        exponentEncoded.append(contentsOf: lengthField(of: exponent))
        exponentEncoded.append(contentsOf: exponent)

        // combine these INTEGERs to a SEQUENCE -> PKCS#1 key
        var sequenceEncoded: [UInt8] = [0x30]
        sequenceEncoded.append(contentsOf: lengthField(of: (modulusEncoded + exponentEncoded)))
        sequenceEncoded.append(contentsOf: (modulusEncoded + exponentEncoded))

        // Create the SecKey
        let keyData = Data(sequenceEncoded)
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: modulus.count * 8
        ]
        var error: Unmanaged<CFError>?
        let publicKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error)
        //print("publicKey:", publicKey ?? "👎")
        return publicKey
    }

    // Aux method to calculate a byte array length
    func lengthField(of valueField: [UInt8]) -> [UInt8] {
        var count = valueField.count

        if count < 128 {
            return [ UInt8(count) ]
        }

        // The number of bytes needed to encode count.
        let lengthBytesCount = Int((log2(Double(count)) / 8) + 1)

        // The first byte in the length field encoding the number of remaining bytes.
        let firstLengthFieldByte = UInt8(128 + lengthBytesCount)

        var lengthField: [UInt8] = []
        for _ in 0..<lengthBytesCount {

            let lengthByte = UInt8(count & 0xff) // last 8 bits of count.
            lengthField.insert(lengthByte, at: 0)
            count = count >> 8 // Delete the last 8 bits of count.
        }

        // Include the first byte.
        lengthField.insert(firstLengthFieldByte, at: 0)
        return lengthField
    }

    // Convert a String to big endian byte array
    func getByteArrayFromHex(inputString: String) -> [UInt8] {
        return Array<UInt8>.init(hex: inputString)
    }

    func getByteArray(inputString: String) -> [UInt8] {
        let bytes = inputString.utf8
        return [UInt8](bytes)
    }

    /// Encrypt a plain text using a public key
    func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)

        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)

        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
}

extension PLPasswordEncryptionUseCase: Cancelable {
    public func cancel() {}
}

// MARK: I/O types definition
struct PLPasswordEncryptionUseCaseInput {
    let plainPassword: String
    let encryptionKey: EncryptionKeyEntity
}

struct PLPasswordEncryptionUseCaseOutput {
    let encryptedPassword: String
}
