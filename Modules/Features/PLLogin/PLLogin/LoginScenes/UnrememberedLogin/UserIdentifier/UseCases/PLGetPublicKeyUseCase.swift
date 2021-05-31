//
//  PLGetPublicKeyUseCase.swift
//  PLLogin

import Commons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons

final class PLGetPublicKeyUseCase: UseCase<Void, PLGetPublicKeyUseCaseOkOutput, PLGetPublicKeyUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLGetPublicKeyUseCaseOkOutput, PLGetPublicKeyUseCaseErrorOutput> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let result = try managerProvider.getLoginManager().getPubKey()
        switch result {
        case .success(let pubKeyData):
            return UseCaseResponse.ok(PLGetPublicKeyUseCaseOkOutput(modulus: pubKeyData.modulus, exponent: pubKeyData.exponent))
        case .failure(_):
            // TODO: the error management will be implemented in next sprint.
            return UseCaseResponse.error(PLGetPublicKeyUseCaseErrorOutput(loginErrorType: .unauthorized))
        }
    }
}

extension PLGetPublicKeyUseCase: Cancelable {
    public func cancel() {}
}

// MARK: I/O types definition
final class PLGetPublicKeyUseCaseErrorOutput: StringErrorOutput {
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

public struct PLGetPublicKeyUseCaseOkOutput {
    public let modulus: String
    public let exponent: String
}
