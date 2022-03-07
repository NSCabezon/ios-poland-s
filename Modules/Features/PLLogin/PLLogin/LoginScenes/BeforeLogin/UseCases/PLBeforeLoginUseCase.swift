//
//  PLBeforeLoginUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 27/9/21.
//

import CoreFoundationLib
import PLCommons
import SANLegacyLibrary
import SANPLLibrary
import PLCryptography

public final class PLBeforeLoginUseCase: UseCase<Void, PLBeforeLoginUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
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
        case .success(let response):
            let response = PLBeforeLoginUseCaseOutput(isTrustedDevice: true,
                                                      userId: response.userId,
                                                      isBiometricsAvailable: response.containsBiometrics(),
                                                      isPinAvailable: response.containsPin())
                                                    
            return .ok(response)
        case .failure(let error):
            switch error {
            case .unprocessableEntity:
                managerProvider.getTrustedDeviceManager().deleteTrustedDeviceHeaders()
                managerProvider.getTrustedDeviceManager().deleteDeviceId()
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

public struct PLBeforeLoginUseCaseOutput {
    public let userId: Int
    let isTrustedDevice: Bool
    let isBiometricsAvailable: Bool
    let isPinAvailable: Bool
    
    init(isTrustedDevice: Bool, userId: Int = 0, isBiometricsAvailable: Bool = false, isPinAvailable: Bool = false) {
        self.userId = userId
        self.isTrustedDevice = isTrustedDevice
        self.isBiometricsAvailable = isBiometricsAvailable
        self.isPinAvailable = isPinAvailable
    }
}
