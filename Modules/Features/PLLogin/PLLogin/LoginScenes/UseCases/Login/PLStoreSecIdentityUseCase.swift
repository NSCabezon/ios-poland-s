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

final class PLStoreSecIdentityUseCase: UseCase<PLStoreSecIdentityUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>> {

    public override func executeUseCase(requestValues: PLStoreSecIdentityUseCaseInput) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        try SecIdentity.updateSecIdentity(secIdentity: requestValues.identity, label: requestValues.label)
        return UseCaseResponse.ok()
    }
}

// MARK: I/O types definition
struct PLStoreSecIdentityUseCaseInput {
    let label: String
    let identity: SecIdentity
}
