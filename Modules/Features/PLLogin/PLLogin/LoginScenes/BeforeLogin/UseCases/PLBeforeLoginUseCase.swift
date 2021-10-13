//
//  PLBeforeLoginUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 27/9/21.
//


import Repository
import DomainCommon
import Commons
import PLCommons
import SANLegacyLibrary
import SANPLLibrary

final class PLBeforeLoginUseCase: UseCase<Void, PLBeforeLoginUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    private let dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLBeforeLoginUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        
        guard let trustedDeviceAppId = managerProvider.getTrustedDeviceManager().getTrustedDeviceHeaders()?.appId else {
            return .ok(PLBeforeLoginUseCaseOutput(isTrustedDevice: false))
        }

        let parameters = BeforeLoginParameters(trustedDeviceAppId: trustedDeviceAppId,
                                               retrieveOptions: ["TRUSTED_DEVICE", "CERTIFICATE"])
        let result = try managerProvider.getTrustedDeviceManager().doBeforeLogin(parameters)
        switch result {
        case .success(_):
            return .ok(PLBeforeLoginUseCaseOutput(isTrustedDevice: true))
        case .failure(let error):
            switch error {
            case .unprocessableEntity:
                managerProvider.getTrustedDeviceManager().deleteTrustedDeviceHeaders()
                return .ok(PLBeforeLoginUseCaseOutput(isTrustedDevice: false))
            default:
                return .error(self.handle(error: error))
            }
        }
    }
    
    private func setFirstLaunch(manager: PLManagersProviderProtocol) {
        guard var appInfo = manager.getLoginManager().getAppInfo() else {
            let newAppInfo = AppInfo(isFirstLaunch: false)
            manager.getLoginManager().setAppInfo(newAppInfo)
            return
        }
        appInfo.isFirstLaunch = false
        manager.getLoginManager().setAppInfo(appInfo)
    }
}

struct PLBeforeLoginUseCaseOutput {
    let isTrustedDevice: Bool
}
