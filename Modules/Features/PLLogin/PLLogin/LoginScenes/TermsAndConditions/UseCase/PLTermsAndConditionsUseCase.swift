//
//  PLTermsAndConditionsUseCase.swift
//  Account
//
//  Created by Mario Rosales Maillo on 4/2/22.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary
import PLCommons


public final class PLTermsAndConditionsUseCase: UseCase<PLTermsAndConditionsUseCaseInput, PLTermsAndConditionsUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let termsAndConditionsRepository: PLTermsAndConditionsRepository

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.termsAndConditionsRepository = dependenciesResolver.resolve(for: PLTermsAndConditionsRepository.self)
    }
    
    override public func executeUseCase(requestValues: PLTermsAndConditionsUseCaseInput) throws -> UseCaseResponse<PLTermsAndConditionsUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let loginManager: PLLoginManagerProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getLoginManager()
        
        let appInfo = loginManager.getAppInfo()
        var userTermsVersion = appInfo?.acceptedTermsVersion ?? 0

        guard let terms = self.termsAndConditionsRepository.get() else {
            return .error(PLUseCaseErrorOutput(errorDescription: "Missing terms and conditions"))
        }
        
        if requestValues.acceptCurrentVersion {
            let appInfo = AppInfo(isFirstLaunch: appInfo?.isFirstLaunch ?? true, acceptedTermsVersion: terms.version)
            loginManager.setAppInfo(appInfo)
            userTermsVersion = terms.version
        }
        
        let needAcceptance = userTermsVersion < terms.version
        return .ok(PLTermsAndConditionsUseCaseOutput(shouldPresentTerms: needAcceptance, terms: terms))
    }
}

public struct PLTermsAndConditionsUseCaseOutput {
    public let shouldPresentTerms: Bool
    public let version: Int
    public let title: String
    public let description: String
    
    public init(shouldPresentTerms: Bool, terms:PLTermsAndConditionsDTO) {
        self.shouldPresentTerms = shouldPresentTerms
        self.version = terms.version
        self.title = terms.title
        self.description = terms.description
    }
}

public struct PLTermsAndConditionsUseCaseInput {
    let acceptCurrentVersion: Bool
}
