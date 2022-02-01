//
//  PLSessionUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/7/21.
//

import CoreFoundationLib
import CoreFoundationLib
import SANPLLibrary
import PLCommons

final class PLSessionUseCase: UseCase<Void, Void, PLUseCaseErrorOutput<LoginErrorType>> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private var sessionManager: CoreSessionManager {
        return self.dependenciesResolver.resolve(for: CoreSessionManager.self)
    }
    
    private lazy var sessionDataManager: SessionDataManager = {
        let manager = self.dependenciesResolver.resolve(for: SessionDataManager.self)
        manager.setDataManagerDelegate(self)
        return manager
    }()

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, PLUseCaseErrorOutput<LoginErrorType>> {
        sessionManager.sessionStarted(completion: nil)
        sessionDataManager.load()
        return .ok()
    }
}


extension PLSessionUseCase: SessionDataManagerDelegate {
    func willLoadSession() {
        dependenciesResolver.resolve(for: PfmControllerProtocol.self).cancelAll()
    }
}
