//
//  PLRegisterConfirmUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 12/8/21.
//

import CoreFoundationLib
import PLCommons
import SANPLLibrary

final class PLRegisterConfirmUseCase: UseCase<PLRegisterConfirmUseCaseInput, PLRegisterConfirmUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    private let dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLRegisterConfirmUseCaseInput) throws -> UseCaseResponse<PLRegisterConfirmUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {

        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        do {
            let parameters = RegisterConfirmParameters(pinSoftwareTokenId: requestValues.pinSoftwareTokenId,
                                                       timestamp: requestValues.timestamp,
                                                       secondFactorResponse: SecondFactorResponse(device: requestValues.secondFactorResponseDevice,
                                                                                                  value: requestValues.secondFactorResponseValue))
            let result = try managerProvider.getTrustedDeviceManager().doConfirmRegistration(parameters)
            switch result {
            case .success(let confirmRegistration):
                let output = PLRegisterConfirmUseCaseOkOutput(id: confirmRegistration.id,
                                                              state: confirmRegistration.state,
                                                              badTriesCount: confirmRegistration.badTriesCount,
                                                              triesAllowed: confirmRegistration.triesAllowed,
                                                              timestamp: confirmRegistration.timestamp,
                                                              name: confirmRegistration.name,
                                                              key: confirmRegistration.key,
                                                              type: confirmRegistration.type,
                                                              trustedDeviceId: confirmRegistration.trustedDeviceId,
                                                              dateOfLastStatusChange: confirmRegistration.dateOfLastStatusChange,
                                                              properUseCount: confirmRegistration.properUseCount,
                                                              badUseCount: confirmRegistration.badUseCount,
                                                              dateOfLastProperUse: confirmRegistration.dateOfLastProperUse,
                                                              dateOfLastBadUse: confirmRegistration.dateOfLastBadUse)
                return .ok(output)

            case .failure(let error):
                return .error(self.handle(error: error))
            }
        } catch {
            return .error(PLUseCaseErrorOutput(errorDescription: "Confirm registration failed: \(error.localizedDescription)" ))
        }
    }
}

struct PLRegisterConfirmUseCaseInput {
    let pinSoftwareTokenId: Int
    let timestamp: Int
    let secondFactorResponseDevice: String
    let secondFactorResponseValue: String
}

struct PLRegisterConfirmUseCaseOkOutput {
    let id: Int
    let state: String
    let badTriesCount: Int
    let triesAllowed: Int
    let timestamp: Int
    let name: String?
    let key: String?
    let type: String?
    let trustedDeviceId: Int?
    let dateOfLastStatusChange: String?
    let properUseCount: Int?
    let badUseCount: Int?
    let dateOfLastProperUse: String?
    let dateOfLastBadUse: String?
}
