//
//  PLFirstLaunchUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 21/9/21.
//

import CoreFoundationLib
import PLCommons
import SANLegacyLibrary
import SANPLLibrary

final class PLFirstLaunchUseCase: UseCase<PLFirstLaunchUseCaseInput, PLFirstLaunchUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
    private let dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLFirstLaunchUseCaseInput) throws -> UseCaseResponse<PLFirstLaunchUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let isFirstLaunch = managerProvider.getLoginManager().getAppInfo()?.isFirstLaunch ?? true
        if requestValues.shouldSetFirstLaunch {
            setFirstLaunch(manager: managerProvider)
        }
        return .ok(PLFirstLaunchUseCaseOutput(isFirstLaunch: isFirstLaunch))
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

struct PLFirstLaunchUseCaseOutput {
    let isFirstLaunch: Bool
}

struct PLFirstLaunchUseCaseInput {
    let shouldSetFirstLaunch: Bool
}
