//
//  PLDeviceDataCertificateCreationUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 23/6/21.
//

import Commons
import PLCommons
import DomainCommon
import CryptoSwift
import os
import PLSelfSignedCertificate

private struct PLCertificate {
    let pemCertificate: String
    let publicKey: SecKey
    let privateKey: SecKey
}

final class PLDeviceDataCertificateCreationUseCase: UseCase<PLDeviceDataCertificateCreationUseCaseInput, PLDeviceDataCertificateCreationUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLDeviceDataCertificateCreationUseCaseInput) throws -> UseCaseResponse<PLDeviceDataCertificateCreationUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {

        do {
            let certificate = try self.createCertificate()
            return .ok(PLDeviceDataCertificateCreationUseCaseOutput(certificate: certificate.pemCertificate,
                                                                                   publicKey: certificate.publicKey,
                                                                                   privateKey: certificate.privateKey))
        } catch {
            return .error(PLUseCaseErrorOutput(errorDescription: error.localizedDescription))
        }
    }
}

private extension PLDeviceDataCertificateCreationUseCase {

    enum Constants {
        static let keySize: Int = 1024
        static let keysTag = "OneApp.TrustedDevice"
        enum CertificateParameters {
            static let commonName = "Santander"
            static let organizationName = "Santander Bank Polska S.A."
            static let countryName = "PL"
        }
    }
}

// MARK: I/O types definition
struct PLDeviceDataCertificateCreationUseCaseInput {
}

struct PLDeviceDataCertificateCreationUseCaseOutput {
    let certificate: String
    let publicKey: SecKey
    let privateKey: SecKey
}

// MARK: Private extension
private extension PLDeviceDataCertificateCreationUseCase {

    func createCertificate() throws -> PLCertificate {

        let secIdentity = SecIdentity.create(ofSize: 2048, subjectCommonName: "Santander", subjectOrganizationName: "Santander Bank Polska S.A.", contryName: "PL")

        guard let certificate = secIdentity?.certificate?.data.base64EncodedString(),
              let publicKey = secIdentity?.certificate?.publicKey,
              let privateKey = secIdentity?.privateKey else {
            os_log("❌ [TRUSTED DEVICE][Device Data] Error creating certificate", log: .default, type: .error)
            throw PLDeviceDataEncryptionError.certificateCreationError
        }

        var error: Unmanaged<CFError>? = nil
        let publicKeyB64 = (SecKeyCopyExternalRepresentation(publicKey, &error) as Data?)?.base64EncodedString()
        let privateKeyDataB64 = (SecKeyCopyExternalRepresentation(privateKey, &error) as Data?)?.base64EncodedString()
        let certificatePEM = certificate.addPEMformat(header: String.PEMFormats.certificate.header, footer: String.PEMFormats.certificate.footer)

        os_log("✅ [TRUSTED DEVICE][Device Data] Certificate generated: %@", log: .default, type: .info, certificate)
        os_log("✅ [TRUSTED DEVICE][Device Data] Certificate generated (PEM FORMAT): %@", log: .default, type: .info, certificatePEM)
        os_log("✅ [TRUSTED DEVICE][Device Data] Public key: %@", log: .default, type: .info, publicKeyB64?.addPEMformat(header: String.PEMFormats.publicKey.header, footer: String.PEMFormats.publicKey.footer) ?? "")
        os_log("✅ [TRUSTED DEVICE][Device Data] Private key: %@", log: .default, type: .info, privateKeyDataB64?.addPEMformat(header: String.PEMFormats.privateKey.header, footer: String.PEMFormats.privateKey.footer) ?? "")

        return PLCertificate(pemCertificate: certificatePEM,
                             publicKey: publicKey,
                             privateKey: privateKey)
    }
}


private extension String {

    enum PEMFormats {
        static let newLine = "\n"
        enum certificate {
            static let header = "-----BEGIN CERTIFICATE-----\n"
            static let footer = "\n-----END CERTIFICATE-----\n"
        }
        enum privateKey {
            static let header = "-----BEGIN RSA PRIVATE KEY-----\n"
            static let footer = "\n-----END RSA PRIVATE KEY-----"
        }
        enum publicKey {
            static let header = "-----BEGIN PUBLIC KEY-----\n"
            static let footer = "\n-----END PUBLIC KEY-----"

        }
    }

    func addPEMformat(header: String, footer: String) -> String {
        let pemFormatted = header + self.unfoldSubSequences(limitedTo: 64).joined(separator: "\n") + footer
        return pemFormatted
    }
}

private extension Collection {
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: maxLength, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return self[start..<end]
        }
    }
}
