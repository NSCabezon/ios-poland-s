//
//  PLGetPublicKeyUseCase.swift
//  PLLogin

import Commons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons

final class PLGetPublicKeyUseCase: UseCase<Void, PLGetPublicKeyUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLGetPublicKeyUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let result = try managerProvider.getLoginManager().getPubKey()
        switch result {
        case .success(let pubKeyData):
            return UseCaseResponse.ok(PLGetPublicKeyUseCaseOkOutput(modulus: pubKeyData.modulus, exponent: pubKeyData.exponent))
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

extension PLGetPublicKeyUseCase: Cancelable {
    public func cancel() {}
}

// MARK: I/O types definition
public struct PLGetPublicKeyUseCaseOkOutput {
    public let modulus: String
    public let exponent: String
}
