//
//  PLSessionUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/7/21.
//

import Commons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons

final class PLSessionUseCase: UseCase<Void, Void, PLUseCaseErrorOutput<LoginErrorType>> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private var sessionController: SessionControllerProtocol {
        return self.dependenciesResolver.resolve(for: SessionControllerProtocol.self)
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        sessionController.openSession(completion: nil)
        sessionController.setLoginTime(date: Date())
        return .ok()
    }
}
