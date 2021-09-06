//
//  PLValidateVersionUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 1/9/21.
//

import Foundation
import Commons
import PLCommons
import DomainCommon
import Repository

final class PLValidateVersionUseCase: UseCase<Void, Void, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    
    var dependenciesResolver: DependenciesResolver
    private lazy var appConfig: AppConfigRepositoryProtocol = {
        return self.dependenciesResolver.resolve(for: AppConfigRepositoryProtocol.self)
    }()
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
        
    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        let appActive = self.appConfig.getBool(LoginConstants.appConfigActive) ?? false
        if appActive == false {
            return .error(PLUseCaseErrorOutput(error: .versionBlocked(error: "DEPRECATED_VERSION")))
        }
        return .ok()
    }
}
