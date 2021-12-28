//
//  PLTrustedDeviceInfoUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 14/10/21.
//

import CoreFoundationLib
import Commons
import PLCommons
import SANLegacyLibrary
import SANPLLibrary
import PLCryptography

final class PLTrustedDeviceInfoUseCase: UseCase<PLTrustedDeviceInfoInput, PLTrustedDeviceInfoOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    private let dependenciesResolver: DependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLTrustedDeviceInfoInput) throws -> UseCaseResponse<PLTrustedDeviceInfoOutput, PLUseCaseErrorOutput<LoginErrorType>> {

        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = TrustedDeviceInfoParameters(trustedDeviceAppId: requestValues.trustedDeviceAppId)
        let result = try managerProvider.getTrustedDeviceManager().getTrustedDeviceInfo(parameters)
        
        guard managerProvider.getTrustedDeviceManager().getTrustedDeviceHeaders() != nil else {
            return .error(PLUseCaseErrorOutput(error: .unauthorized))
        }
        
        switch result {
        case .success(let response):
            let result = PLTrustedDeviceInfoOutput(dto: response)
            managerProvider.getTrustedDeviceManager().storeTrustedDeviceInfo(result.info)
            return .ok(result)
        case .failure(let error):
            managerProvider.getTrustedDeviceManager().deleteTrustedDeviceHeaders()
            managerProvider.getTrustedDeviceManager().deleteDeviceId()
            return .error(self.handle(error: error))
        }
    }
}

struct PLTrustedDeviceInfoOutput {
    let info: TrustedDeviceInfo
    init(dto: TrustedDeviceInfoDTO) {
        self.info = TrustedDeviceInfo(dto: dto)
    }
}

struct PLTrustedDeviceInfoInput {
    let trustedDeviceAppId: String
}
