//
//  PLLoginUseCase.swift
//  PLLogin

import Commons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons

final class PLLoginUseCase: UseCase<PLLoginUseCaseInput, PLLoginUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLLoginUseCaseInput) throws -> UseCaseResponse<PLLoginUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = LoginParameters(userId: requestValues.userId, userAlias: requestValues.userAlias)
        let result = try managerProvider.getLoginManager().doLogin(parameters)
        switch result {
        case .success(let loginData):
            
            // TODO: Check if loginData.userId must be a string
            let challenge = getChallenge(from: loginData.secondFactorData)
            let trustedComputer = TrustedComputerEntity(state: loginData.trustedComputerData?.state,
                                                        register: loginData.trustedComputerData?.register)
            let loginOutput = PLLoginUseCaseOkOutput(userId: loginData.userId,
                                                     loginImage: loginData.loginImageData,
                                                     passwordMaskEnabled: loginData.passwordMaskEnabled,
                                                     passwordMask: loginData.passwordMask,
                                                     defaultChallenge: challenge,
                                                     trustedComputerData: trustedComputer,
                                                     secondFactorFinalState: loginData.secondFactorData.finalState,
                                                     unblockRemainingTimeInSecs: loginData.secondFactorData.unblockAvailableIn)

            guard loginData.isBlocked() == false else {
                return UseCaseResponse.error(PLUseCaseErrorOutput(error: .temporaryLocked))
            }
            return UseCaseResponse.ok(loginOutput)
        case .failure(let error):
            return .error(self.handle(error: error))
        }
    }
}

private extension PLLoginUseCase {
    func getEnvironment() -> BSANPLEnvironmentDTO? {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let result = managerProvider.getEnvironmentsManager().getCurrentEnvironment()
        switch result {
        case .success(let dto):
            return dto
        case .failure:
            return nil
        }
    }
    
    func getChallenge(from secondFactorData: SecondFactorDataDTO) -> ChallengeEntity {
        let challenge: ChallengeEntity
        let defaultChallenge = secondFactorData.defaultChallenge
        switch defaultChallenge.authorizationType {
        case .softwareToken:
            if let smsChallenge = secondFactorData.challenges?.first(where: { $0.authorizationType == .sms }) {
                challenge = ChallengeEntity(authorizationType: smsChallenge.authorizationType,
                                            value: smsChallenge.value)
            } else if let hardwareChallenge = secondFactorData.challenges?.first(where: { $0.authorizationType == .tokenTime || $0.authorizationType == .tokenTimeCR }) {
                challenge = ChallengeEntity(authorizationType: hardwareChallenge.authorizationType,
                                            value: hardwareChallenge.value)
            } else {
                challenge = ChallengeEntity(authorizationType: defaultChallenge.authorizationType,
                                            value: defaultChallenge.value)
            }
        default:
            challenge = ChallengeEntity(authorizationType: defaultChallenge.authorizationType,
                                        value: defaultChallenge.value)
        }
        return challenge
    }
}

extension PLLoginUseCase: Cancelable {
    public func cancel() {}
}

// MARK: I/O types definition
struct PLLoginUseCaseInput {
    let userId: String?
    let userAlias: String?
}

public struct PLLoginUseCaseOkOutput {
    public let userId: Int
    public let loginImage: String?
    public let passwordMaskEnabled: Bool?
    public let passwordMask: Int?
    public let defaultChallenge: ChallengeEntity
    public let trustedComputerData: TrustedComputerEntity?
    public let secondFactorFinalState: String
    public let unblockRemainingTimeInSecs: Double?
}
