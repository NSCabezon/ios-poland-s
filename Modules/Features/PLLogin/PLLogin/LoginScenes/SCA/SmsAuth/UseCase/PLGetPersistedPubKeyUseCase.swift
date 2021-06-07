//
//  PLGetPersistedPubKeyUseCase.swift
//  PLLogin

import Commons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons

final class PLGetPersistedPubKeyUseCase: UseCase<Void, PLGetPersistedPubKeyUseCaseOkOutput, PLAuthenticateUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLGetPersistedPubKeyUseCaseOkOutput, PLAuthenticateUseCaseErrorOutput> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        do {
            let publicKeyData = try managerProvider.getLoginManager().getPersistedPubKey()
            return .ok(PLGetPersistedPubKeyUseCaseOkOutput(modulus: publicKeyData.modulus, exponent: publicKeyData.exponent))
        } catch {
            return .error(PLAuthenticateUseCaseErrorOutput("Public key not available"))
        }
    }
}

extension PLGetPersistedPubKeyUseCase: Cancelable {
    public func cancel() {}
}

// MARK: I/O types definition
final class PLGetPersistedPubKeyUseCaseErrorOutput: StringErrorOutput {
    public var loginErrorType: LoginErrorType?

    public init(loginErrorType: LoginErrorType?) {
        self.loginErrorType = loginErrorType
        super.init(nil)
    }

    public override init(_ errorDesc: String?) {
        self.loginErrorType = LoginErrorType.serviceFault
        super.init(errorDesc)
    }

    public func getLoginErrorType() -> LoginErrorType? {
        return loginErrorType
    }
}

public struct PLGetPersistedPubKeyUseCaseOkOutput {
    public let modulus: String
    public let exponent: String
}
