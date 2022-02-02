//
//  PLConfirmationCodeRegisterUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 12/8/21.
//
import CoreFoundationLib
import PLCommons
import SANPLLibrary

final class PLConfirmationCodeRegisterUseCase: UseCase<PLPLConfirmationCodeRegisterInput, Void, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public override func executeUseCase(requestValues: PLPLConfirmationCodeRegisterInput) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = RegisterConfirmationCodeParameters(trustedDeviceId: requestValues.trustedDeviceId,
                                                            secondFactorSmsChallenge: requestValues.secondFactorSmsChallenge,
                                                            language: requestValues.language)
        
        let result = try managerProvider.getTrustedDeviceManager().doRegisterConfirmationCode(parameters)
        switch result {
        case .success():
            return UseCaseResponse.ok()
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

// MARK: I/O types definition
struct PLPLConfirmationCodeRegisterInput {
    let trustedDeviceId: String
    let secondFactorSmsChallenge: String
    let language: String
}
