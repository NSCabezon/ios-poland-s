//
//  PLLoginProcessUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 24/8/21.
//

import Foundation
import Commons
import PLCommons

final class PLUnrememberedLoginProcessGroup: ProcessGroup <PLUnrememberedLoginProcessGroupInput, PLUnrememberedLoginProcessGroupOutput, PLUnrememberedLoginProcessGroupError> {

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
        self.dependenciesEngine.resolve(for: PLSetDemoUserUseCase.self)
    }

    override func registerDependencies() {
        self.dependenciesEngine.register(for: PLLoginUseCase.self) { resolver in
            return PLLoginUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLGetPublicKeyUseCase.self) { resolver in
            return PLGetPublicKeyUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLLoginChallengeSelectionUseCase.self) { resolver in
            return PLLoginChallengeSelectionUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLSetDemoUserUseCase.self) { resolver in
            return PLSetDemoUserUseCase(dependenciesResolver: resolver)
        }
    }

    override func execute(input: PLUnrememberedLoginProcessGroupInput,
                          completion: @escaping (Result<PLUnrememberedLoginProcessGroupOutput, PLUnrememberedLoginProcessGroupError>) -> Void) {

        let identifierType = self.getIdentifierType(input.identification)
        let identification = input.identification
        var configuration: UnrememberedLoginConfiguration? = nil
        var challengeUseCaseOutput:PLLoginUseCaseOkOutput? = nil
        let demoUserInput = PLSetDemoUserUseCaseInput(userId: input.identification)
        var isDemoUser: Bool = false

        Scenario(useCase: setDemoUserUseCase, input: demoUserInput)
            .execute(on: self.dependenciesEngine.resolve())
            .then(scenario: { (output) ->Scenario<PLLoginUseCaseInput, PLLoginUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> in
                let caseInput: PLLoginUseCaseInput
                switch identifierType {
                case .nik:
                    caseInput = PLLoginUseCaseInput(userId: identification, userAlias: nil)
                case .alias:
                    caseInput = PLLoginUseCaseInput(userId: nil, userAlias: identification)
                }
                isDemoUser = output.isDemoUser
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
                let userId = isDemoUser ? identification : String(challengeUseCaseOutput.userId)
                configuration = UnrememberedLoginConfiguration(displayUserIdentifier: identification,
                                                               userIdentifier: userId,
                                                               passwordType: passwordType,
                                                               challenge: output.challengeEntity,
                                                               loginImageData: challengeUseCaseOutput.loginImage,
                                                               password: nil,
                                                               secondFactorDataFinalState: challengeUseCaseOutput.secondFactorFinalState,
                                                               unblockRemainingTimeInSecs: challengeUseCaseOutput.unblockRemainingTimeInSecs)
                return Scenario(useCase: self.getPublicKeyUseCase)
            })
            .onSuccess { _ in
                guard let configuration = configuration else { return }
                completion(.success(PLUnrememberedLoginProcessGroupOutput(configuration: configuration)))
            }
            .onError { error in
                completion(.failure(PLUnrememberedLoginProcessGroupError(error: error)))
            }
        }
}

private extension PLUnrememberedLoginProcessGroup {

    enum PLUserIdentifierType {
        case nik
        case alias
    }

    func getIdentifierType(_ identifier: String) -> PLUserIdentifierType {
        let characters = CharacterSet.decimalDigits.inverted
        if !identifier.isEmpty && identifier.rangeOfCharacter(from: characters) == nil && identifier.count == 8 {
            return .nik
        } else {
            return .alias
        }
    }
}

public struct PLUnrememberedLoginProcessGroupInput {
    let identification: String
}

public struct PLUnrememberedLoginProcessGroupOutput {
    let configuration: UnrememberedLoginConfiguration
}

public struct PLUnrememberedLoginProcessGroupError: Error {
    let error: UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>
}
