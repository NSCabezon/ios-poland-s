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

    private var challengeSelectionUseCase: PLLoginChallengeSelectionUseCase {
        self.dependenciesEngine.resolve(for: PLLoginChallengeSelectionUseCase.self)
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

        self.dependenciesEngine.register(for: PLLoginChallengeSelectionUseCase.self) { resolver in
            return PLLoginChallengeSelectionUseCase(dependenciesResolver: resolver)
        }
    }
    
    public func executeNonPersistedLogin(type: LoginType, identification: String,
                        onSuccess: @escaping (UnrememberedLoginConfiguration?) -> Void,
                        onFailure: @escaping (UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>) -> Void) {

        let identifierType = self.getIdentifierType(identification)
        var configuration: UnrememberedLoginConfiguration? = nil
        var challengeUseCaseOutput:PLLoginUseCaseOkOutput? = nil
        let demoUserInput = PLSetDemoUserUseCaseInput(userId: identification)

        Scenario(useCase: setDemoUserUseCase, input: demoUserInput)
            .execute(on: self.dependenciesEngine.resolve())
            .then(scenario: { (_) ->Scenario<PLLoginUseCaseInput, PLLoginUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> in
                let caseInput: PLLoginUseCaseInput
                switch identifierType {
                case .nik:
                    caseInput = PLLoginUseCaseInput(userId: identification, userAlias: nil)
                case .alias:
                    caseInput = PLLoginUseCaseInput(userId: nil, userAlias: identification)
                }
                return Scenario(useCase: self.loginUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] output ->Scenario<PLLoginChallengeSelectionUseCaseInput, PLLoginChallengeSelectionUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                challengeUseCaseOutput = output
                let loginChallengeSelectionInput = PLLoginChallengeSelectionUseCaseInput(challenges: output.secondFactorData.challenges,
                                                                                         defaultChallenge: output.secondFactorData.defaultChallenge)
                return Scenario(useCase: self.challengeSelectionUseCase, input: loginChallengeSelectionInput)
            })
            .then(scenario: { [weak self] output ->Scenario<Void, PLGetPublicKeyUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self,
                      let challengeUseCaseOutput = challengeUseCaseOutput else { return nil }
                var passwordType = PasswordType.normal
                if challengeUseCaseOutput.passwordMaskEnabled == true, let mask = challengeUseCaseOutput.passwordMask {
                    passwordType = PasswordType.masked(mask: mask)
                }
                configuration = UnrememberedLoginConfiguration(userIdentifier: String(challengeUseCaseOutput.userId),
                                                               passwordType: passwordType,
                                                               challenge: output.challengeEntity,
                                                               loginImageData: challengeUseCaseOutput.loginImage,
                                                               password: nil,
                                                               secondFactorDataFinalState: challengeUseCaseOutput.secondFactorFinalState,
                                                               unblockRemainingTimeInSecs: challengeUseCaseOutput.unblockRemainingTimeInSecs)
                return Scenario(useCase: self.getPublicKeyUseCase)
            })
            .onSuccess { _ in
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
