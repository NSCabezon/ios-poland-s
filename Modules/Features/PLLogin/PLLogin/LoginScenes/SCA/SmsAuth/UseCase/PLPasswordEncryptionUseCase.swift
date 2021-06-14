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
import SwiftyRSA

/**
    This use case encrypt a password plain text using a public key and returns a encrypted string
 */
protocol PLPasswordEncryptionUseCaseProtocol: UseCase<PLPasswordEncryptionUseCaseInput, PLPasswordEncryptionUseCaseOutput, PLPasswordEncryptionUseCaseErrorOutput> {}

final class PLPasswordEncryptionUseCase: UseCase<PLPasswordEncryptionUseCaseInput, PLPasswordEncryptionUseCaseOutput, PLPasswordEncryptionUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLPasswordEncryptionUseCaseInput) throws -> UseCaseResponse<PLPasswordEncryptionUseCaseOutput, PLPasswordEncryptionUseCaseErrorOutput> {
        do {
            let encryptedPassword = try self.encryptPassword(password: requestValues.plainPassword, encryptionKey: requestValues.encryptionKey)
            return UseCaseResponse.ok(PLPasswordEncryptionUseCaseOutput(encryptedPassword: encryptedPassword))
        } catch {
            return UseCaseResponse.error(PLPasswordEncryptionUseCaseErrorOutput(error.localizedDescription))
        }
    }
}

private extension PLPasswordEncryptionUseCase {
    func getEnvironment() -> BSANPLEnvironmentDTO? {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let result = managerProvider.getEnvironmentsManager().getCurrentEnvironment()
        switch result {
        case .success(let dto):
            return dto
        case .failure:
            return nil
        }
    }

    func encryptPassword(password: String, encryptionKey: EncryptionKeyEntity) throws -> String {
        guard let secPublicKey = self.getPublicKeySecurityRepresentation(encryptionKey.modulus, exponent: encryptionKey.exponent) else {
            throw EncryptionError.publicKeyGenerationFailed
        }
        var encryptedBase64String = ""
        let publicKey = try PublicKey(reference: secPublicKey)
        let clear = try ClearMessage(string: password, using: .utf8)
        let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
        encryptedBase64String = encrypted.base64String

        return encryptedBase64String
    }

    /// Process modulus and exponent to generate an Apple Security SecKey
    func getPublicKeySecurityRepresentation(_ modulus: String, exponent: String) -> SecKey? {
        let modulusData = Data(base64Encoded: modulus)!
        var modulus = [UInt8](modulusData)
        modulus.insert(0x00, at: 0) // prefix with 0x00 to indicate that it is a non-negative number
        print("modulus, size \(modulus.count):", modulus)

        let exponentData = Data(base64Encoded: exponent)!
        let exponent = [UInt8](exponentData) // encode the exponent as big-endian bytes
        print("exponent:", exponent)


        // encode the modulus and exponent as INTEGERs
        var modulusEncoded: [UInt8] = [0x02]
        modulusEncoded.append(contentsOf: lengthField(of: modulus))
        modulusEncoded.append(contentsOf: modulus)

        var exponentEncoded: [UInt8] = [0x02]
        exponentEncoded.append(contentsOf: lengthField(of: exponent))
        exponentEncoded.append(contentsOf: exponent)

        // combine these INTEGERs to a SEQUENCE
        var sequenceEncoded: [UInt8] = [0x30]
        sequenceEncoded.append(contentsOf: lengthField(of: (modulusEncoded + exponentEncoded)))
        sequenceEncoded.append(contentsOf: (modulusEncoded + exponentEncoded))
        print("encoded key:",sequenceEncoded)


        // Create the SecKey
        let keyData = Data(sequenceEncoded)
        print("encoded key, base64:", keyData.base64EncodedString())
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: modulus.count * 8
        ]
        var error: Unmanaged<CFError>?
        let publicKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error)
        print("publicKey:", publicKey ?? "👎")
        print("error:", error ?? "👍")
        return publicKey
    }

    func getPublicKeySecurityRepresentation2(_ modulus: String, exponent: String) -> SecKey? {
        var byteArrModulus = Array(modulus.utf8)
        let byteArrayExponent = Array(exponent.utf8)

        // Process modulus and exponent to generate an Apple Security SecKey
        byteArrModulus.insert(0x00, at: 0)

        var modulusEncoded: [UInt8] = []
        modulusEncoded.append(0x02)
        modulusEncoded.append(contentsOf: lengthField(of: byteArrModulus))
        modulusEncoded.append(contentsOf: byteArrModulus)

        var exponentEncoded: [UInt8] = []
        exponentEncoded.append(0x02)
        exponentEncoded.append(contentsOf: lengthField(of: byteArrayExponent))
        exponentEncoded.append(contentsOf: byteArrayExponent)

        var sequenceEncoded: [UInt8] = []
        sequenceEncoded.append(0x30)
        sequenceEncoded.append(contentsOf: lengthField(of: (modulusEncoded + exponentEncoded)))
        sequenceEncoded.append(contentsOf: (modulusEncoded + exponentEncoded))

        // Create the SecKey
        let keyData = Data(sequenceEncoded)
        let keySize = (byteArrModulus.count * 8)
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: keySize
        ]
        let publicKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, nil)

        return publicKey
    }

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

final class PLPasswordEncryptionUseCaseErrorOutput: StringErrorOutput {
    public var loginErrorType: LoginErrorType?

    public init(loginErrorType: LoginErrorType?) {
        self.loginErrorType = loginErrorType
        super.init(nil)
    }

    public override init(_ errorDesc: String?) {
        self.loginErrorType = LoginErrorType.serviceFault
        super.init(errorDesc)
    }

    public func getLoginErrorType() -> LoginErrorType? {
        return loginErrorType
    }
}
