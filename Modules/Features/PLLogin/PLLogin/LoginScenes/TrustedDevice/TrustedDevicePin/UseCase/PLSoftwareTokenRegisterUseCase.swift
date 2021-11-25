//
//  PLSoftwareTokenRegisterUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 30/6/21.
//

import Commons
import PLCommons
import CoreFoundationLib
import SANPLLibrary

final class PLSoftwareTokenRegisterUseCase: UseCase<PLSoftwareTokenRegisterUseCaseInput, PLSoftwareTokenRegisterUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLSoftwareTokenRegisterUseCaseInput) throws -> UseCaseResponse<PLSoftwareTokenRegisterUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = RegisterSoftwareTokenParameters(createBiometricsToken: requestValues.createBiometricsToken,
                                                         trustedDeviceAuth: TrustedDeviceAuthData(appId: requestValues.appId,
                                                                                                  parameters: requestValues.parameters,
                                                                                                  deviceTime: requestValues.deviceTime))
        let result = try managerProvider.getTrustedDeviceManager().doRegisterSoftwareToken(parameters)
        switch result {
        case .success(let registerSoftwareToken):
            guard registerSoftwareToken.tokens.count > 0 else {
                throw  PLUseCaseErrorOutput<LoginErrorType>(errorDescription: "Any token received")
            }
            
            var softTokens = [TrustedDeviceSoftwareToken]()
            for token in registerSoftwareToken.tokens {
                softTokens.append(TrustedDeviceSoftwareToken(name: token.name, key: token.key, type: token.type,
                                                             state: token.state, id: token.id, timestamp: token.timestamp))
            }
            let registerOutput = PLSoftwareTokenRegisterUseCaseOutput(tokens: softTokens,
                                                                      trustedDeviceState: registerSoftwareToken.trustedDeviceState)
            return .ok(registerOutput)

        case .failure(let error):
            return .error(self.handle(error: error))
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
    let tokens: [TrustedDeviceSoftwareToken]
    let trustedDeviceState: String
}

public struct TrustedDeviceSoftwareToken: Codable {
    public let name, key, type, state: String
    public let id, timestamp: Int
}

public extension TrustedDeviceSoftwareToken {

    var typeMapped: SoftwareTokenType {
        switch self.type.uppercased() {
        case "PIN":
            return .PIN
        case "BIOMETRICS":
            return .BIOMETRICS
        default:
            return .UNKNOWN
        }
    }
}
