//
//  PLDevicesUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 3/8/21.
//

import CoreFoundationLib
import PLCommons
import SANPLLibrary

final class PLDevicesUseCase: UseCase<Void, PLDevicesUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLDevicesUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        
        let result = try managerProvider.getTrustedDeviceManager().getDevices()
        switch result {
        case .success(let devices):
            let output = PLDevicesUseCaseOutput(defaultAuthorizationType: devices.defaultAuthorizationType,
                                                allowedAuthorizationTypes: devices.allowedAuthorizationTypes,
                                                availableAuthorizationTypes: devices.availableAuthorizationTypes)
            return UseCaseResponse.ok(output)
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

// MARK: I/O types definition
struct PLDevicesUseCaseOutput {
    public let defaultAuthorizationType: AuthorizationType
    public let allowedAuthorizationTypes: [AuthorizationType]
    public let availableAuthorizationTypes: [AuthorizationType]
}
