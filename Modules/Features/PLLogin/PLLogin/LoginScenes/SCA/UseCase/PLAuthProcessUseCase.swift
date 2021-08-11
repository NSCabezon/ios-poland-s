//
//  PLAuthProcessUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 29/7/21.
//

import Commons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons

final class PLAuthProcessUseCase {
    var dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    private var persistedPubKeyUseCase: PLGetPersistedPubKeyUseCase {
        self.dependenciesEngine.resolve(for: PLGetPersistedPubKeyUseCase.self)
    }
    
    private var authenticateUseCase: PLAuthenticateUseCase {
        self.dependenciesEngine.resolve(for: PLAuthenticateUseCase.self)
    }
    
    private var encryptPasswordUseCase: PLPasswordEncryptionUseCase {
        self.dependenciesEngine.resolve(for: PLPasswordEncryptionUseCase.self)
    }
    
    private var getNextSceneUseCase: PLGetLoginNextSceneUseCase {
        return self.dependenciesEngine.resolve(for: PLGetLoginNextSceneUseCase.self)
    }
    
    private var sessionUseCase: PLSessionUseCase {
        self.dependenciesEngine.resolve(for: PLSessionUseCase.self)
    }

    public init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
        
        self.dependenciesEngine.register(for: PLAuthenticateUseCase.self) { resolver in
            return PLAuthenticateUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLPasswordEncryptionUseCase.self) { resolver in
           return PLPasswordEncryptionUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLGetPersistedPubKeyUseCase.self) { resolver in
           return PLGetPersistedPubKeyUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLGetLoginNextSceneUseCase.self) { resolver in
            return PLGetLoginNextSceneUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLSessionUseCase.self) { resolver in
            return PLSessionUseCase(dependenciesResolver: resolver)
        }
    }
    
    public func execute(input: PLAuthProcessInput,
                        onSuccess: @escaping (PLGetLoginNextSceneUseCaseOkOutput) -> Void,
                        onFailure: @escaping (UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>) -> Void) {
        
        let secondFactorAuthentity = SecondFactorDataAuthenticationEntity(challenge: input.challenge,
                                                                          value: input.scaCode)
        
        Scenario(useCase: self.persistedPubKeyUseCase)
            .execute(on: self.dependenciesEngine.resolve())
            .then(scenario: {  [weak self] (pubKeyOutput) -> Scenario<PLPasswordEncryptionUseCaseInput, PLPasswordEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                let encrytionKey = EncryptionKeyEntity(modulus: pubKeyOutput.modulus, exponent: pubKeyOutput.exponent)
                let useCaseInput = PLPasswordEncryptionUseCaseInput(plainPassword: input.password,
                                                                    encryptionKey: encrytionKey)
                return Scenario(useCase: self.encryptPasswordUseCase, input: useCaseInput)
            })
            .then(scenario: {  [weak self] (encryptedPasswordOutput) -> Scenario<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }

                let useCaseInput = PLAuthenticateUseCaseInput(encryptedPassword: encryptedPasswordOutput.encryptedPassword,
                                                              userId: input.userId,
                                                              secondFactorData: secondFactorAuthentity)
                
                return Scenario(useCase: self.authenticateUseCase, input: useCaseInput)
            })
            .then(scenario: { [weak self] _ -> Scenario<Void, Void,PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil}
                return Scenario(useCase: self.sessionUseCase)
            })
            .then(scenario: { [weak self] _ -> Scenario<Void, PLGetLoginNextSceneUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil}
                return Scenario(useCase: self.getNextSceneUseCase)
            })
            .onSuccess({ nextSceneResult in
                 onSuccess(nextSceneResult)
            })
            .onError { error in
                onFailure(error)
            }
    }
}

// MARK: I/O types definition
struct PLAuthProcessInput {
    let scaCode, password, userId: String
    let challenge: ChallengeEntity
}
