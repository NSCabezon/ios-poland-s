//
//  PLTrustedDeviceGetHeadersUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 25/10/21.
//

import Foundation

import Repository
import DomainCommon
import Commons
import PLCommons
import SANPLLibrary

final class PLTrustedDeviceGetHeadersUseCase: UseCase<Void, PLTrustedDeviceGetHeadersUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
    private let dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLTrustedDeviceGetHeadersUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()
        let trustedDeviceHeaders = trustedDeviceManager.getTrustedDeviceHeaders()
        return .ok(PLTrustedDeviceGetHeadersUseCaseOutput(parameters: trustedDeviceHeaders?.parameters, time: trustedDeviceHeaders?.time, appId: trustedDeviceHeaders?.appId))
    }
}

struct PLTrustedDeviceGetHeadersUseCaseOutput {
    let parameters: String?
    let time: String?
    let appId: String?
}
