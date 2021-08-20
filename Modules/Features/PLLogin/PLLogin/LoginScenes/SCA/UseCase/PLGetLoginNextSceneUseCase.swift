//
//  PLGetLoginNextSceneUseCase.swift
//  PLLogin

import Repository
import DomainCommon
import Commons
import PLCommons
import iOSCommonPublicFiles
import SANLegacyLibrary
import SANPLLibrary

/// This useCase returns the next scene from SMS unremembered login step. NOTE that temporally it is decided using the property enableOtpPush. In the next sprints this will be subtituted with the real property when it will be defined.
final class PLGetLoginNextSceneUseCase: UseCase<Void, PLGetLoginNextSceneUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
    private let dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLGetLoginNextSceneUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let appConfigRepository: AppConfigRepositoryProtocol = self.dependenciesResolver.resolve(for: AppConfigRepositoryProtocol.self)

        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()

        if let _ = trustedDeviceManager.getTrustedDeviceHeaders() {
            return .ok(PLGetLoginNextSceneUseCaseOkOutput(nextScene: .globalPositionScene))
        } else {
            let appConfigEnableOtpPush = appConfigRepository.getBool("enableOtpPush")
            return appConfigEnableOtpPush == true ? .ok(PLGetLoginNextSceneUseCaseOkOutput(nextScene: .trustedDeviceScene)): .ok(PLGetLoginNextSceneUseCaseOkOutput(nextScene: .globalPositionScene))
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

