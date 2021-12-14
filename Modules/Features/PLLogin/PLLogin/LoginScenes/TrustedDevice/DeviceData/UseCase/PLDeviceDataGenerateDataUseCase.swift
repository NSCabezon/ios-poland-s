//
//  PLDeviceDataGenerateDataUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 31/8/21.
//

import Commons
import PLCommons
import CoreFoundationLib
import CryptoSwift
import SANPLLibrary

final class PLDeviceDataGenerateDataUseCase: UseCase<PLDeviceDataGenerateDataUseCaseInput, PLDeviceDataGenerateDataUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    private let dependenciesResolver: DependenciesResolver
    lazy private var trustedHeadersProvider: PLTrustedHeadersGenerable = {
        dependenciesResolver.resolve(for: PLTrustedHeadersGenerable.self)
    }()
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLDeviceDataGenerateDataUseCaseInput) throws -> UseCaseResponse<PLDeviceDataGenerateDataUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let deviceData = trustedHeadersProvider.generateDeviceData(
            transactionParameters: nil,
            isTrustedDevice: requestValues.isTrustedDevice
        )
        let useCaseOutput = PLDeviceDataGenerateDataUseCaseOutput(deviceData: deviceData)
        return .ok(useCaseOutput)
    }
}

struct PLDeviceDataGenerateDataUseCaseInput {
    let isTrustedDevice: Bool
}

struct PLDeviceDataGenerateDataUseCaseOutput {
    let deviceData: DeviceData
}
