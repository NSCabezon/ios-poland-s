//
//  PLLoginUseCase.swift
//  PLLogin

import CoreFoundationLib
import CoreFoundationLib
import SANPLLibrary
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
            let trustedComputer = TrustedComputerEntity(state: loginData.trustedComputerData?.state,
                                                        register: loginData.trustedComputerData?.register)
            let secondFactorChallengeEntities = loginData.secondFactorData.challenges?.compactMap{ ChallengeEntity(authorizationType: $0.authorizationType,
                                                                                                                   value: $0.value)
            }
            let defaultChallenge = ChallengeEntity(authorizationType: loginData.secondFactorData.defaultChallenge.authorizationType,
                                                    value: loginData.secondFactorData.defaultChallenge.value)
            let secondFactorData = SecondFactorDataEntity(finalState: loginData.secondFactorData.finalState,
                                                          challenges: secondFactorChallengeEntities,
                                                          defaultChallenge: defaultChallenge,
                                                          expired: loginData.secondFactorData.expired,
                                                          unblockAvailableIn: loginData.secondFactorData.unblockAvailableIn)
            let loginOutput = PLLoginUseCaseOkOutput(userId: loginData.userId,
                                                     loginImage: loginData.loginImageData,
                                                     passwordMaskEnabled: loginData.passwordMaskEnabled,
                                                     passwordMask: loginData.passwordMask,
                                                     secondFactorData:  secondFactorData,
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
    public let secondFactorData: SecondFactorDataEntity
    public let trustedComputerData: TrustedComputerEntity?
    public let secondFactorFinalState: String
    public let unblockRemainingTimeInSecs: Double?
}
