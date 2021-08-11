//
//  PLGetPersistedPubKeyUseCase.swift
//  PLLogin

import Commons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons

final class PLGetPersistedPubKeyUseCase: UseCase<Void, PLGetPersistedPubKeyUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLGetPersistedPubKeyUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        do {
            let publicKeyData = try managerProvider.getLoginManager().getPersistedPubKey()
            return .ok(PLGetPersistedPubKeyUseCaseOkOutput(modulus: publicKeyData.modulus, exponent: publicKeyData.exponent))
        } catch {
            return .error(PLUseCaseErrorOutput(errorDescription: "Public key not available"))
        }
    }
}

extension PLGetPersistedPubKeyUseCase: Cancelable {
    public func cancel() {}
}

// MARK: I/O types definition

public struct PLGetPersistedPubKeyUseCaseOkOutput {
    public let modulus: String
    public let exponent: String
}
