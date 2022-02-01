//
//  ConfirmPinUseCase.swift
//  Santander
//
//  Created by Cristobal Ramos Laina on 8/11/21.
//

import Foundation
import CoreFoundationLib
import CoreDomain
import CoreFoundationLib
import SANPLLibrary
import PLCommons

final class ConfirmPinUseCase: UseCase<ConfirmPinUseCaseInput, ConfirmPinUseCaseOkOutput, PLUseCaseErrorOutput<StringErrorOutput>> {
    
    let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: ConfirmPinUseCaseInput) throws -> UseCaseResponse<ConfirmPinUseCaseOkOutput, PLUseCaseErrorOutput<StringErrorOutput>> {
        let repository = dependenciesResolver.resolve(for: PLOneAuthorizationProcessorRepository.self)
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let trustedDeviceId = managerProvider.getTrustedDeviceManager().getStoredTrustedDeviceInfo()?.trustedDeviceId
        let appRepository = self.dependenciesResolver.resolve(for: AppRepositoryProtocol.self)
        let userId = try appRepository.getPersistedUser().getResponseData()?.userId ?? ""
        let parameters = ConfirmChallengeParameters(userId: nil,
                                                    trustedDeviceId: trustedDeviceId ?? 0,
                                                    softwareTokenType: requestValues.softwareTokenType,
                                                    trustedDeviceCertificate: requestValues.trustedDeviceCertificate,
                                                    authorizationData: requestValues.authorizationData)
        let result = try repository.confirmPin(authorizationId: requestValues.authorizationId, parameters: parameters)
        switch result {
        case .success:
            return .ok(ConfirmPinUseCaseOkOutput())
        case .failure(let error):
            return .error(PLUseCaseErrorOutput(errorDescription: error.localizedDescription))
        }
    }
}

struct ConfirmPinUseCaseInput {
    let authorizationId: String
    let softwareTokenType: String
    let trustedDeviceCertificate: String
    let authorizationData: String
}

struct ConfirmPinUseCaseOkOutput: ChallengeVerificationRepresentable {}
