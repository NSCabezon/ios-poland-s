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
        guard let secPublicKey = self.getPublicKeySecurityRepresentation(encryptionKey.modulus, exponentStr: encryptionKey.exponent, password: password) else {
            throw EncryptionError.publicKeyGenerationFailed
        }
        if let encryptedString = self.encrypt(string: password, publicKey: secPublicKey) {
            return encryptedString
        }
        throw EncryptionError.publicKeyGenerationFailed
    }

    /// Process modulus and exponent to generate an pem with base 64 public key
    func getPublicKeySecurityRepresentation(_ modulusStr: String, exponentStr: String, password: String) -> SecKey? {
        guard let base64EncodedKey = RSAConverter.pemFrom(mod: modulusStr, exp: exponentStr),
              let keyData = Data(base64Encoded: base64EncodedKey) else { return nil }
        let publicKey = SecKeyCreateWithData(keyData as NSData, [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
        ] as NSDictionary, nil)
        return publicKey
    }

    /// Encrypt a plain text using a public key
    func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)
        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)

        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        let hexEncondedString = Data(bytes: keyBuffer, count: keySize).toHexString().lowercased()
        return hexEncondedString
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
