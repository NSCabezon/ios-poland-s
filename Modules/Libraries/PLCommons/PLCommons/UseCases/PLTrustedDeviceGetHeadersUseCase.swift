//
//  PLTrustedDeviceGetHeadersUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 25/10/21.
//

import Foundation
import CoreFoundationLib
import Commons
import SANPLLibrary

public final class PLTrustedDeviceGetHeadersUseCase<Error>: UseCase<Void, PLTrustedDeviceGetHeadersUseCaseOutput, PLUseCaseErrorOutput<Error>> {
    private let dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLTrustedDeviceGetHeadersUseCaseOutput, PLUseCaseErrorOutput<Error>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()
        let trustedDeviceHeaders = trustedDeviceManager.getTrustedDeviceHeaders()
        return .ok(PLTrustedDeviceGetHeadersUseCaseOutput(parameters: trustedDeviceHeaders?.parameters, time: trustedDeviceHeaders?.time, appId: trustedDeviceHeaders?.appId))
    }
}

public struct PLTrustedDeviceGetHeadersUseCaseOutput {
    public let parameters: String?
    public let time: String?
    public let appId: String?
    
    public init(parameters: String?, time: String?, appId: String?) {
        self.parameters = parameters
        self.time = time
        self.appId = appId
    }
}
