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
import CertificateSigningRequest

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
            return UseCaseResponse.ok(PLDeviceDataCertificateCreationUseCaseOutput(certificate: certificate))
        } catch {
            return UseCaseResponse.error(PLDeviceDataUseCaseErrorOutput(error.localizedDescription))
        }
    }
}

private extension PLDeviceDataCertificateCreationUseCase {

    enum Constants {
        static let keySize: Int = 1024
    }

    func generateCertificate() throws -> String {
        let random = PLLoginTrustedDeviceHelpers.secureRandom(bytesNumber: 2)?.toHexString() ?? ""
        let tagPrivate = "OneApp.TrustedDevice.private.\(random)"
        let tagPublic = "OneApp.TrustedDevice.public.\(random)"
        let keyAlgorithm = KeyAlgorithm.rsa(signatureType: .sha256)
        //let sizeOfKey = keyAlgorithm.availableKeySizes[1]
        let sizeOfKey = 1024

        let (potentialPrivateKey, potentialPublicKey) =
            self.generateKeysAndStoreInKeychain(keyAlgorithm, keySize: sizeOfKey,
                                                tagPrivate: tagPrivate, tagPublic: tagPublic)
        guard let privateKey = potentialPrivateKey,
              let publicKey = potentialPublicKey else {
            throw PLDeviceDataEncryptionError.certificateCreationError
        }

        let (potentialPublicKeyBits, potentialPublicKeyBlockSize) =
            self.getPublicKeyBits(keyAlgorithm,
                                  publicKey: publicKey, tagPublic: tagPublic)
        guard let publicKeyBits = potentialPublicKeyBits,
              potentialPublicKeyBlockSize != nil else {
            throw PLDeviceDataEncryptionError.certificateCreationError
        }

        // TODO: We will probably need to add the dates (notBefore, notAfter) to certificate and create a X509v3 instead of v1
        let algorithm = KeyAlgorithm.rsa(signatureType: .sha256)
                let csr = CertificateSigningRequest(commonName: "Santander",
                                                    organizationName: "Santander Bank Polska S.A.",
                                                    countryName: "PL",
                                                    keyAlgorithm: algorithm)

        guard let builtCSR = csr.buildCSRAndReturnString(publicKeyBits, privateKey: privateKey, publicKey: publicKey) else {
            throw PLDeviceDataEncryptionError.certificateCreationError
        }

        let certificate = builtCSR
            .replacingOccurrences(of: "-----BEGIN CERTIFICATE REQUEST-----", with: "-----BEGIN CERTIFICATE-----")
            .replacingOccurrences(of: "-----END CERTIFICATE REQUEST-----", with: "-----END CERTIFICATE-----")
        print("Certificate generated: \(certificate)")
        return certificate
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
    let certificate: String
}

// MARK: Private extension
private extension PLDeviceDataCertificateCreationUseCase {
    func generateKeysAndStoreInKeychain(_ algorithm: KeyAlgorithm, keySize: Int,
                                        tagPrivate: String, tagPublic: String) -> (SecKey?, SecKey?) {
        let publicKeyParameters: [String: Any] = [
            String(kSecAttrIsPermanent): true,
            String(kSecAttrAccessible): kSecAttrAccessibleAfterFirstUnlock,
            String(kSecAttrApplicationTag): tagPublic.data(using: .utf8)!
        ]

        let privateKeyParameters: [String: Any] = [
            String(kSecAttrIsPermanent): true,
            String(kSecAttrAccessible): kSecAttrAccessibleAfterFirstUnlock,
            String(kSecAttrApplicationTag): tagPrivate.data(using: .utf8)!
        ]

        //Define what type of keys to be generated here
        let parameters: [String: Any] = [
            String(kSecAttrKeyType): algorithm.secKeyAttrType,
            String(kSecAttrKeySizeInBits): keySize,
            String(kSecReturnRef): true,
            String(kSecPublicKeyAttrs): publicKeyParameters,
            String(kSecPrivateKeyAttrs): privateKeyParameters
        ]

        //Use Apple Security Framework to generate keys, save them to application keychain
        var error: Unmanaged<CFError>?
        let privateKey = SecKeyCreateRandomKey(parameters as CFDictionary, &error)
        if privateKey == nil {
            print("Error creating keys occured: \(error!.takeRetainedValue() as Error), keys weren't created")
            return (nil, nil)
        }

        //Get generated public key
        let query: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrKeyType): algorithm.secKeyAttrType,
            String(kSecAttrApplicationTag): tagPublic.data(using: .utf8)!,
            String(kSecReturnRef): true
        ]

        var publicKeyReturn: CFTypeRef?
        let result = SecItemCopyMatching(query as CFDictionary, &publicKeyReturn)
        if result != errSecSuccess {
            print("Error getting publicKey fron keychain occured: \(result)")
            return (privateKey, nil)
        }
        // swiftlint:disable:next force_cast
        let publicKey = publicKeyReturn as! SecKey?
        return (privateKey, publicKey)
    }

    func getPublicKeyBits(_ algorithm: KeyAlgorithm, publicKey: SecKey, tagPublic: String) -> (Data?, Int?) {
        //Set block size
        let keyBlockSize = SecKeyGetBlockSize(publicKey)
        //Ask keychain to provide the publicKey in bits
        let query: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrKeyType): algorithm.secKeyAttrType,
            String(kSecAttrApplicationTag): tagPublic.data(using: .utf8)!,
            String(kSecReturnData): true
        ]

        var tempPublicKeyBits: CFTypeRef?
        var _ = SecItemCopyMatching(query as CFDictionary, &tempPublicKeyBits)

        guard let keyBits = tempPublicKeyBits as? Data else {
            return (nil, nil)
        }

        return (keyBits, keyBlockSize)
    }
}
