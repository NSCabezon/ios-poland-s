//
//  PLIvrRegisterUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 2/8/21.
//

import Commons
import PLCommons
import DomainCommon
import SANPLLibrary

final class PLIvrRegisterUseCase: UseCase<PLIvrRegisterUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public override func executeUseCase(requestValues: PLIvrRegisterUseCaseInput) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = RegisterIvrParameters(trustedDeviceId: requestValues.trustedDeviceId)
        
        let result = try managerProvider.getTrustedDeviceManager().doRegisterIvr(parameters)
        switch result {
        case .success():
            return UseCaseResponse.ok()
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

// MARK: I/O types definition
struct PLIvrRegisterUseCaseInput {
    let trustedDeviceId: String
}
