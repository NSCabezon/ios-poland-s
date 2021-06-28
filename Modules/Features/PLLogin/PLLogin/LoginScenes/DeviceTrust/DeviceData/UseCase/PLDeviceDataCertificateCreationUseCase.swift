//
//  PLDeviceDataCertificateCreationUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 23/6/21.
//

import Commons
import DomainCommon
import PLCommons
import CryptoSwift

private struct PLCertificate {
    let publicKey: String
    let privateKey: String
}

final class PLDeviceDataCertificateCreationUseCase: UseCase<PLDeviceDataCertificateCreationUseCaseInput, PLDeviceDataCertificateCreationUseCaseOutput, PLDeviceDataUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLDeviceDataCertificateCreationUseCaseInput) throws -> UseCaseResponse<PLDeviceDataCertificateCreationUseCaseOutput, PLDeviceDataUseCaseErrorOutput> {

        do {
            let certificate = try self.generateCertificate()
            return UseCaseResponse.ok(PLDeviceDataCertificateCreationUseCaseOutput(publicKey: certificate.publicKey,
                                                                                   privateKey: certificate.privateKey))
        } catch {
            return UseCaseResponse.error(PLDeviceDataUseCaseErrorOutput(error.localizedDescription))
        }
    }
}

private extension PLDeviceDataCertificateCreationUseCase {

    enum Constants {
        static let keySize: Int = 1024
    }

    func generateCertificate() throws -> PLCertificate {

        guard
            let publicKeyTag = PLLoginTrustedDeviceHelpers.secureRandom(bytesNumber: 16)?.toHexString().data(using: String.Encoding.utf8) as NSObject?,
            let privateKeyTag = PLLoginTrustedDeviceHelpers.secureRandom(bytesNumber: 16)?.toHexString().data(using: String.Encoding.utf8) as NSObject?
        else {
            throw PLDeviceDataEncryptionError.certificateCreationError
        }

        let publicKeyAttr: [NSObject: NSObject] = [
            kSecAttrIsPermanent:true as NSObject,
            kSecAttrApplicationTag: publicKeyTag,
            kSecClass: kSecClassKey,
            kSecReturnData: kCFBooleanTrue]
        let privateKeyAttr: [NSObject: NSObject] = [
            kSecAttrIsPermanent:true as NSObject,
            kSecAttrApplicationTag: privateKeyTag,
            kSecClass: kSecClassKey,
            kSecReturnData: kCFBooleanTrue]

        var keyPairAttr = [NSObject: NSObject]()
        keyPairAttr[kSecAttrKeyType] = kSecAttrKeyTypeRSA
        keyPairAttr[kSecAttrKeySizeInBits] = Constants.keySize as NSObject
        keyPairAttr[kSecPublicKeyAttrs] = publicKeyAttr as NSObject
        keyPairAttr[kSecPrivateKeyAttrs] = privateKeyAttr as NSObject

        var publicKey : SecKey?
        var privateKey : SecKey?;

        let statusCode = SecKeyGeneratePair(keyPairAttr as CFDictionary, &publicKey, &privateKey)

        guard statusCode == noErr && publicKey != nil && privateKey != nil else {
            throw PLDeviceDataEncryptionError.certificateCreationError
        }

        var resultPublicKey: AnyObject?
        var resultPrivateKey: AnyObject?
        let statusPublicKey = SecItemCopyMatching(publicKeyAttr as CFDictionary, &resultPublicKey)
        let statusPrivateKey = SecItemCopyMatching(privateKeyAttr as CFDictionary, &resultPrivateKey)

        guard statusPublicKey == noErr,
              let publicKeyData = resultPublicKey as? Data else {
            throw PLDeviceDataEncryptionError.certificateCreationError
        }

        guard statusPrivateKey == noErr,
              let privateKeyData = resultPrivateKey as? Data else {
            throw PLDeviceDataEncryptionError.certificateCreationError
        }

        return PLCertificate(publicKey: publicKeyData.base64EncodedString().addPEMformat(),
                             privateKey: privateKeyData.base64EncodedString())
    }
}

private extension String {
    func addPEMformat() -> String {
        return "-----BEGIN CERTIFICATE-----" + self + "-----END CERTIFICATE-----"
    }
}

// MARK: I/O types definition
struct PLDeviceDataCertificateCreationUseCaseInput {
}

struct PLDeviceDataCertificateCreationUseCaseOutput {
    let publicKey: String
    let privateKey: String
}


