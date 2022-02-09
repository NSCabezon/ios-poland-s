//
//  PLIvrRegisterUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 2/8/21.
//

import CoreFoundationLib
import PLCommons
import SANPLLibrary

final class PLIvrRegisterUseCase: UseCase<PLIvrRegisterUseCaseInput, String, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public override func executeUseCase(requestValues: PLIvrRegisterUseCaseInput) throws -> UseCaseResponse<String, PLUseCaseErrorOutput<LoginErrorType>> {
        
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = RegisterIvrParameters(trustedDeviceId: requestValues.trustedDeviceId)
        
        let result = try managerProvider.getTrustedDeviceManager().doRegisterIvr(parameters)
        switch result {
        case .success(let data):
            guard let code = String(data: data, encoding: .utf8)?.substring(ofLast: 4) else {
                return .error(PLUseCaseErrorOutput(error: .emptyField))
            }
            return UseCaseResponse.ok(code)
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

// MARK: I/O types definition
struct PLIvrRegisterUseCaseInput {
    let trustedDeviceId: String
}
