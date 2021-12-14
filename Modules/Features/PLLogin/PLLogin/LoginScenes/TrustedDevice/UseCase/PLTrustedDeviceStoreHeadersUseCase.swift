//
//  PLTrustedDeviceStoreHeadersUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 18/8/21.
//

import Repository
import CoreFoundationLib
import Commons
import PLCommons
import SANLegacyLibrary
import SANPLLibrary

final class PLTrustedDeviceStoreHeadersUseCase: UseCase<PLTrustedDeviceStoreHeadersInput, Void, PLUseCaseErrorOutput<LoginErrorType>> {
    private let dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLTrustedDeviceStoreHeadersInput) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()
        let trustedDeviceHeders = TrustedDeviceHeaders(parameters: requestValues.parameters,
                                                       time: requestValues.time,
                                                       appId: requestValues.appId)
        trustedDeviceManager.storeTrustedDeviceHeaders(trustedDeviceHeders)
        return .ok()
    }
}

struct PLTrustedDeviceStoreHeadersInput {
    let parameters: String
    let time: String
    let appId: String
}
