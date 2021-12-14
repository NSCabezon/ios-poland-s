//
//  PLDeviceDataCertificateCreationUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 23/6/21.
//

import Commons
import PLCommons
import CoreFoundationLib
import CryptoSwift
import os
import SelfSignedCertificate

final class PLDeviceDataCertificateCreationUseCase: UseCase<PLDeviceDataCertificateCreationUseCaseInput, PLDeviceDataCertificateCreationUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLDeviceDataCertificateCreationUseCaseInput) throws -> UseCaseResponse<PLDeviceDataCertificateCreationUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {

        do {
            let identity = try self.createCertificate()
            return .ok(PLDeviceDataCertificateCreationUseCaseOutput(identity: identity))
            
        } catch {
            return .error(PLUseCaseErrorOutput(errorDescription: error.localizedDescription))
        }
    }
}

private extension PLDeviceDataCertificateCreationUseCase {

    enum Constants {
        static let keysTag = "OneApp.TrustedDevice"
        enum CertificateParameters {
            static let keySize: UInt = 2048
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
    let identity: SecIdentity
}

// MARK: Private extension
private extension PLDeviceDataCertificateCreationUseCase {

    func createCertificate() throws -> SecIdentity {
        let secIdentity = SecIdentity.create(ofSize: Constants.CertificateParameters.keySize,
                                             subjectCommonName: Constants.CertificateParameters.commonName,
                                             subjectOrganizationName: Constants.CertificateParameters.organizationName,
                                             contryName: Constants.CertificateParameters.countryName)

        guard let identity = secIdentity
        else {
            os_log("❌ [TRUSTED DEVICE][Device Data] Error creating certificate", log: .default, type: .error)
            throw PLDeviceDataEncryptionError.certificateCreationError
        }

        os_log("✅ [TRUSTED DEVICE][Device Data] Certificate generated (PEM FORMAT): %@", log: .default, type: .info, identity.PEMFormattedCertificate())
        os_log("✅ [TRUSTED DEVICE][Device Data] Public key: %@", log: .default, type: .info, identity.PEMFormattedPublicKey())
        os_log("✅ [TRUSTED DEVICE][Device Data] Private key: %@", log: .default, type: .info, identity.PEMFormattedPrivateKey())

        return identity
    }
}
