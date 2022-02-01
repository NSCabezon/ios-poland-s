//
//  PLDeviceDataRegisterDeviceUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 23/6/21.
//

import CoreFoundationLib
import PLCommons
import CoreFoundationLib
import SANPLLibrary

final class PLDeviceDataRegisterDeviceUseCase: UseCase<PLDeviceDataRegisterDeviceUseCaseInput, PLDeviceDataRegisterDeviceUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol{
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLDeviceDataRegisterDeviceUseCaseInput) throws -> UseCaseResponse<PLDeviceDataRegisterDeviceUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = RegisterDeviceParameters(transportKey: requestValues.transportKey,
                                                  deviceParameters: requestValues.deviceParameters,
                                                  deviceTime: requestValues.deviceTime,
                                                  certificate: requestValues.certificate,
                                                  appId: requestValues.appId)
        let result = try managerProvider.getTrustedDeviceManager().doRegisterDevice(parameters)
        switch result {
        case .success(let registerDeviceData):
            let registerOutput = PLDeviceDataRegisterDeviceUseCaseOutput(trustedDeviceState: registerDeviceData.trustedDeviceState,
                                                                         trustedDeviceId: registerDeviceData.trustedDeviceId,
                                                                         userId: registerDeviceData.userId,
                                                                         trustedDeviceTimestamp: registerDeviceData.trustedDeviceTimestamp,
                                                                         ivrInputCode: registerDeviceData.ivrInputCode)
            return .ok(registerOutput)

        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

// MARK: I/O types definition
struct PLDeviceDataRegisterDeviceUseCaseInput {
    let transportKey: String
    let deviceParameters: String
    let deviceTime: String
    let certificate: String
    let appId: String
}

struct PLDeviceDataRegisterDeviceUseCaseOutput {
    let trustedDeviceState: String
    let trustedDeviceId: Int
    let userId: Int
    let trustedDeviceTimestamp: Int
    let ivrInputCode: Int
}
