//
//  PLLoginProcessUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 24/8/21.
//

import Foundation
import Commons
import PLCommons

final class PLLoginProcessUseCase {
    
    var dependenciesEngine: DependenciesResolver & DependenciesInjector

    private var loginUseCase: PLLoginUseCase {
        self.dependenciesEngine.resolve(for: PLLoginUseCase.self)
    }
    
    private var getPublicKeyUseCase: PLGetPublicKeyUseCase {
        self.dependenciesEngine.resolve(for: PLGetPublicKeyUseCase.self)
    }
    
    private var setDemoUserUseCase: PLSetDemoUserUseCase {
        return PLSetDemoUserUseCase(dependenciesResolver: self.dependenciesEngine)
    }
    
    public init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
        
        self.dependenciesEngine.register(for: PLLoginUseCase.self) { resolver in
            return PLLoginUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLGetPublicKeyUseCase.self) { resolver in
            return PLGetPublicKeyUseCase(dependenciesResolver: resolver)
        }
    }
    
    public func executeNonPersistedLogin(type: LoginType, identification: String,
                        onSuccess: @escaping (UnrememberedLoginConfiguration?) -> Void,
                        onFailure: @escaping (UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>) -> Void) {
        
            let identifierType = self.getIdentifierType(identification)
            var caseInput: PLLoginUseCaseInput
            var configuration: UnrememberedLoginConfiguration? = nil
            
            switch identifierType {
            case .nik:
                caseInput = PLLoginUseCaseInput(userId: identification, userAlias: nil)
            case .alias:
                caseInput = PLLoginUseCaseInput(userId: nil, userAlias: identification)
            }
            guard let loginUseCase = self.loginUseCase.setRequestValues(requestValues: caseInput) as? PLLoginUseCase else {
                return
            }
            
            Scenario(useCase: setDemoUserUseCase, input: PLSetDemoUserUseCaseInput(userId: identification))
                .execute(on: self.dependenciesEngine.resolve())
                .then(scenario: { (_) ->Scenario<PLLoginUseCaseInput, PLLoginUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> in
                    return Scenario(useCase: loginUseCase, input: caseInput)
                })
                .then(scenario: { [weak self] output ->Scenario<Void, PLGetPublicKeyUseCaseOkOutput,
                                                                PLUseCaseErrorOutput<LoginErrorType>>? in
                    guard let self = self else { return nil }
                    var passwordType = PasswordType.normal
                    if output.passwordMaskEnabled == true, let mask = output.passwordMask {
                        passwordType = PasswordType.masked(mask: mask)
                    }
                    let challenge = ChallengeEntity(authorizationType: output.defaultChallenge.authorizationType,
                                                    value: output.defaultChallenge.value)
                    configuration = UnrememberedLoginConfiguration(userIdentifier: identification,
                                                                   passwordType: passwordType,
                                                                   challenge: challenge,
                                                                   loginImageData: output.loginImage,
                                                                   password: nil,
                                                                   secondFactorDataFinalState: output.secondFactorFinalState,
                                                                   unblockRemainingTimeInSecs: output.unblockRemainingTimeInSecs)
                    return Scenario(useCase: self.getPublicKeyUseCase)
                })
                .onSuccess {  _ in
                    onSuccess(configuration)
                }
                .onError { error in
                    onFailure(error)
                }
        }
}

private extension PLLoginProcessUseCase {
    
    func getIdentifierType(_ identifier: String) -> UserIdentifierType {
        let characters = CharacterSet.decimalDigits.inverted
        if !identifier.isEmpty && identifier.rangeOfCharacter(from: characters) == nil && identifier.count == 8 {
            return .nik
        } else {
            return .alias
        }
    }
}

public enum UserIdentifierType {
    case nik
    case alias
}
