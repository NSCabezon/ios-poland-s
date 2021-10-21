//
//  PLStoreSecIdentityUseCase.swift
//  PLLogin
//
//  Created by crodrigueza on 20/10/21.
//

import Commons
import DomainCommon
import PLCommons
import SelfSignedCertificate

final class PLStoreSecIdentityUseCase: UseCase<PLStoreSecIdentityUseCaseInput, PLStoreSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<SelfSignedCertificateSecIdentityError>> {

    let subjectCommonName = "Santander"
    let subjectOrganizationName = "Santander Bank Polska S.A."
    let contryName = "PL"

    public override func executeUseCase(requestValues: PLStoreSecIdentityUseCaseInput) throws -> UseCaseResponse<PLStoreSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<SelfSignedCertificateSecIdentityError>> {
        let createdSecIdentity = try SecIdentity.createSecIdentity(subjectCommonName: self.subjectCommonName, subjectOrganizationName: self.subjectOrganizationName, contryName: self.contryName)
        let result = try SecIdentity.updateSecIdentity(secIdentity: createdSecIdentity, label: requestValues.label)

        return UseCaseResponse.ok(PLStoreSecIdentityUseCaseOkOutput(isStored: result))
    }
}

// MARK: I/O types definition
struct PLStoreSecIdentityUseCaseInput {
    let label: String
}

public struct PLStoreSecIdentityUseCaseOkOutput {
    public let isStored: Bool
}
