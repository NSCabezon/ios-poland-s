//
//  PLGetLoginNextSceneUseCase.swift
//  PLLogin

import CoreFoundationLib
import CoreFoundationLib
import PLCommons
import SANPLLibrary

/// This useCase returns the next scene from SMS unremembered login step
final class PLGetLoginNextSceneUseCase: UseCase<Void, PLGetLoginNextSceneUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
    private let dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLGetLoginNextSceneUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()

        if let _ = trustedDeviceManager.getTrustedDeviceHeaders() {
            return .ok(PLGetLoginNextSceneUseCaseOkOutput(nextScene: .globalPositionScene))
        } else {
            return .ok(PLGetLoginNextSceneUseCaseOkOutput(nextScene: .trustedDeviceScene))
        }
    }
}

enum PLUnrememberedLoginNextScene {
    case trustedDeviceScene
    case globalPositionScene
}

struct PLGetLoginNextSceneUseCaseOkOutput {
    let nextScene: PLUnrememberedLoginNextScene
}

