//
//  PLGetSecIdentityUseCase.swift
//  PLLogin
//
//  Created by crodrigueza on 20/10/21.
//

import Commons
import DomainCommon
import PLCommons
import SelfSignedCertificate

final class PLGetSecIdentityUseCase: UseCase<PLGetSecIdentityUseCaseInput, PLGetSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<SelfSignedCertificateSecIdentityError>> {

    public override func executeUseCase(requestValues: PLGetSecIdentityUseCaseInput) throws -> UseCaseResponse<PLGetSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<SelfSignedCertificateSecIdentityError>> {
        let secIdentity = try SecIdentity.getSecIdentity(label: requestValues.label)
        let secCertificate = try SecIdentity.getSecCertificateFromSecIdentity(secIdentity: secIdentity)
        let encodedCertificsate = try SecIdentity.encodeCertificate(secCertificate: secCertificate)
        let privateKey = try SecIdentity.getPrivateKeyFromSecIdentity(secIdentity: secIdentity)
        let publicKey = try SecIdentity.getPublicKeyFromSecIdentity(secIdentity: secIdentity)

        return UseCaseResponse.ok(PLGetSecIdentityUseCaseOkOutput(secIdentity: secIdentity, secCertificate: secCertificate, encodedCertificate: encodedCertificsate, privateKey: privateKey, publicKey: publicKey))
    }
}

// MARK: I/O types definition
struct PLGetSecIdentityUseCaseInput {
    let label: String
}

public struct PLGetSecIdentityUseCaseOkOutput {
    let secIdentity: SecIdentity?
    let secCertificate: SecCertificate?
    let encodedCertificate: String?
    let privateKey: SecKey?
    let publicKey: SecKey?
}
