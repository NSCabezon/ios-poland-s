//
//  PLRememberedLoginChangeUserUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 1/12/21.
//

import Commons
import PLCommons
import CoreFoundationLib
import SANPLLibrary

final class PLRememberedLoginChangeUserUseCase: UseCase<Void, Void, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        managerProvider.getTrustedDeviceManager().deleteTrustedDeviceHeaders()
        managerProvider.getTrustedDeviceManager().deleteDeviceId()
        return .ok()
    }
}
