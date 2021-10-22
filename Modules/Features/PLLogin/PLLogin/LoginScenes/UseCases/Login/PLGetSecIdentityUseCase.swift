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

final class PLGetSecIdentityUseCase: UseCase<PLGetSecIdentityUseCaseInput, PLGetSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {

    public override func executeUseCase(requestValues: PLGetSecIdentityUseCaseInput) throws -> UseCaseResponse<PLGetSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let secIdentity = try SecIdentity.getSecIdentity(label: requestValues.label)

        return UseCaseResponse.ok(PLGetSecIdentityUseCaseOkOutput(secIdentity: secIdentity))
    }
}

// MARK: I/O types definition
struct PLGetSecIdentityUseCaseInput {
    let label: String
}

public struct PLGetSecIdentityUseCaseOkOutput {
    let secIdentity: SecIdentity?
}
