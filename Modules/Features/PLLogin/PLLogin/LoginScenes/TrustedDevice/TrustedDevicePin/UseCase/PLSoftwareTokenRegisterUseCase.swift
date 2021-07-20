//
//  PLSoftwareTokenRegisterUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 30/6/21.
//

import Commons
import DomainCommon
import SANPLLibrary

final class PLSoftwareTokenRegisterUseCase: UseCase<PLSoftwareTokenRegisterUseCaseInput, PLSoftwareTokenRegisterUseCaseOutput, PLSoftwareTokenUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLSoftwareTokenRegisterUseCaseInput) throws -> UseCaseResponse<PLSoftwareTokenRegisterUseCaseOutput, PLSoftwareTokenUseCaseErrorOutput> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = RegisterSoftwareTokenParameters(createBiometricsToken: requestValues.createBiometricsToken, // ??? Depende del dispositivo
                                                         trustedDeviceAuth: TrustedDeviceAuthData(appId: requestValues.appId,
                                                                                                  parameters: requestValues.parameters,
                                                                                                  deviceTime: requestValues.deviceTime))
        let result = try managerProvider.getTrustedDeviceManager().doRegisterSoftwareToken(parameters)
        switch result {
        case .success(let registerSoftwareToken):
            guard registerSoftwareToken.tokens.count > 0 else { throw  PLSoftwareTokenUseCaseErrorOutput("Any token received") }
            let token = registerSoftwareToken.tokens[0]
            let registerOutput = PLSoftwareTokenRegisterUseCaseOutput(id: token.id,
                                                                      name: token.name,
                                                                      key: token.key,
                                                                      timestamp: token.timestamp,
                                                                      type: token.type,
                                                                      state: token.state,
                                                                      trustedDeviceState: registerSoftwareToken.trustedDeviceState)
            return UseCaseResponse.ok(registerOutput)

        case .failure(let error):
            return UseCaseResponse.error(PLSoftwareTokenUseCaseErrorOutput(error.localizedDescription))
        }
    }
}

// MARK: I/O types definition
struct PLSoftwareTokenRegisterUseCaseInput {
    let createBiometricsToken: Bool
    let appId: String
    let parameters: String
    let deviceTime: String
}

struct PLSoftwareTokenRegisterUseCaseOutput {
    let id: String
    let name: String
    let key: String
    let timestamp: Int
    let type: String
    let state: String
    let trustedDeviceState: String
}
