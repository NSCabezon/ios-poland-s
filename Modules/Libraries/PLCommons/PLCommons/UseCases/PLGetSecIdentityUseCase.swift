//
//  PLGetSecIdentityUseCase.swift
//  PLLogin
//
//  Created by crodrigueza on 20/10/21.
//

import Commons
import DomainCommon
import SelfSignedCertificate

public final class PLGetSecIdentityUseCase<Error>: UseCase<PLGetSecIdentityUseCaseInput, PLGetSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<Error>> {

    public override func executeUseCase(requestValues: PLGetSecIdentityUseCaseInput) throws -> UseCaseResponse<PLGetSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<Error>> {
        let secIdentity = SecIdentity.getSecIdentity(label: requestValues.label)

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
