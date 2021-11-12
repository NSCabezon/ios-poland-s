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

public final class PLGetSecIdentityUseCase: UseCase<PLGetSecIdentityUseCaseInput, PLGetSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {

    public override func executeUseCase(requestValues: PLGetSecIdentityUseCaseInput) throws -> UseCaseResponse<PLGetSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let secIdentity = try SecIdentity.getSecIdentity(label: requestValues.label)

        return UseCaseResponse.ok(PLGetSecIdentityUseCaseOkOutput(secIdentity: secIdentity))
    }
}

// MARK: I/O types definition
public struct PLGetSecIdentityUseCaseInput {
    let label: String
    public init(label: String) {
        self.label = label
    }
}

public struct PLGetSecIdentityUseCaseOkOutput {
    public let secIdentity: SecIdentity?
    
    public init(secIdentity: SecIdentity?) {
        self.secIdentity = secIdentity
    }
}
