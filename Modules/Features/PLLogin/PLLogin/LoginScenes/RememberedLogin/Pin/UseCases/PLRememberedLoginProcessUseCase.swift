//
//  PLRememberedLoginProcessUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 19/10/21.
//

import Foundation
import Commons
import PLCommons

final class PLRememberedLoginProcessUseCase {
    var dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    private var loginUseCase: PLLoginUseCase {
        self.dependenciesEngine.resolve(for: PLLoginUseCase.self)
    }
    
    private var setDemoUserUseCase: PLSetDemoUserUseCase {
        return PLSetDemoUserUseCase(dependenciesResolver: self.dependenciesEngine)
    }
    
    private var authenticateInitUseCase: PLAuthenticateInitUseCase {
        self.dependenciesEngine.resolve(for: PLAuthenticateInitUseCase.self)
    }
    
    private var pendingChallengeUseCase: PLRememberedLoginPendingChallengeUseCase {
        self.dependenciesEngine.resolve(for: PLRememberedLoginPendingChallengeUseCase.self)
    }
    
    private var confirmChallengeUseCase: PLRememberedLoginConfirmChallengeUseCase {
        self.dependenciesEngine.resolve(for: PLRememberedLoginConfirmChallengeUseCase.self)
    }
    
    private var authenticateUseCase: PLAuthenticateUseCase {
        self.dependenciesEngine.resolve(for: PLAuthenticateUseCase.self)
    }

    public init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
        
        self.dependenciesEngine.register(for: PLLoginUseCase.self) { resolver in
            return PLLoginUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLAuthenticateInitUseCase.self) { resolver in
           return PLAuthenticateInitUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLRememberedLoginPendingChallengeUseCase.self) { resolver in
           return PLRememberedLoginPendingChallengeUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLRememberedLoginConfirmChallengeUseCase.self) { resolver in
           return PLRememberedLoginConfirmChallengeUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLAuthenticateUseCase.self) { resolver in
           return PLAuthenticateUseCase(dependenciesResolver: resolver)
        }
        
    }
    
    public func executePersistedLogin(configuration: RememberedLoginConfiguration,
                        onSuccess: @escaping (RememberedLoginConfiguration?) -> Void,
                        onFailure: @escaping (UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>) -> Void) {
        
        let identification = configuration.userIdentifier
        let demoUserInput = PLSetDemoUserUseCaseInput(userId: identification)

        Scenario(useCase: setDemoUserUseCase, input: demoUserInput)
            .execute(on: self.dependenciesEngine.resolve())
            .then(scenario: { (_) ->Scenario<PLLoginUseCaseInput, PLLoginUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> in
                let caseInput = PLLoginUseCaseInput(userId: identification, userAlias: nil)
                return Scenario(useCase: self.loginUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] output ->Scenario<PLAuthenticateInitUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                configuration.challenge = output.secondFactorData.defaultChallenge
                let caseInput = PLAuthenticateInitUseCaseInput(userId: identification,
                                                               challenge: output.secondFactorData.defaultChallenge)
                return Scenario(useCase: self.authenticateInitUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] output ->Scenario<PLRememberedLoginPendingChallengeUseCaseInput, PLRememberedLoginPendingChallenge, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                let caseInput = PLRememberedLoginPendingChallengeUseCaseInput(userId: identification)
                return Scenario(useCase: self.pendingChallengeUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] pendingChallenge ->Scenario<PLRememberedLoginConfirmChallengeUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                guard let type = configuration.challenge?.authorizationType else { return nil }

                configuration.pendingChallenge = pendingChallenge
                let certificate = "certificate certificate certificate"
                let authData = "authData authData authData authData"
                let caseInput = PLRememberedLoginConfirmChallengeUseCaseInput(userId: identification,
                                                                              softwareTokenType: type.rawValue,
                                                                              trustedDeviceCertificate: certificate,
                                                                              authorizationData: authData)
                return Scenario(useCase: self.confirmChallengeUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] Void ->Scenario<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                guard let challenge = configuration.challenge else { return nil }
                let authEntity = SecondFactorDataAuthenticationEntity(challenge: challenge, value: "")
                let caseInput = PLAuthenticateUseCaseInput(encryptedPassword: nil,
                                                           userId: identification,
                                                           secondFactorData: authEntity)
                return Scenario(useCase: self.authenticateUseCase, input: caseInput)
            })
            .onSuccess { output in
                onSuccess(configuration)
            }
            .onError { error in
                onFailure(error)
            }
    }
}
