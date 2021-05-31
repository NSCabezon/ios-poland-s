//
//  PLLoginUseCase.swift
//  PLLogin

import Commons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons

final class PLLoginUseCase: UseCase<PLLoginUseCaseInput, PLLoginUseCaseOkOutput, PLLoginUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLLoginUseCaseInput) throws -> UseCaseResponse<PLLoginUseCaseOkOutput, PLLoginUseCaseErrorOutput> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = LoginParameters(userId: requestValues.userId, userAlias: requestValues.userAlias)
        let result = try managerProvider.getLoginManager().doLogin(parameters)
        switch result {
        case .success(let loginData):
            // TODO: Check if loginData.userId must be a string
            let loginChallenge = LoginChallengeEntity(authorizationType: loginData.secondFactorData?.defaultChallenge?.authorizationType,
                value: loginData.secondFactorData?.defaultChallenge?.value)
            let trustedComputer = TrustedComputerEntity(state: loginData.trustedComputerData?.state, register: loginData.trustedComputerData?.register)
            let loginOutput = PLLoginUseCaseOkOutput(userId: loginData.userId, loginImage: loginData.loginImageData ,passwordMaskEnabled: loginData.passwordMaskEnabled, passwordMask: loginData.passwordMask, defaultChallenge: loginChallenge, trustedComputerData: trustedComputer)
            return UseCaseResponse.ok(loginOutput)
        case .failure(_):
                // TODO: the error management will be implemented in next sprint.
                return UseCaseResponse.error(PLLoginUseCaseErrorOutput(loginErrorType: .unauthorized))
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

final class PLLoginUseCaseErrorOutput: StringErrorOutput {
    public var loginErrorType: LoginErrorType?

    public init(loginErrorType: LoginErrorType?) {
        self.loginErrorType = loginErrorType
        super.init(nil)
    }

    public override init(_ errorDesc: String?) {
        self.loginErrorType = LoginErrorType.serviceFault
        super.init(errorDesc)
    }

    public func getLoginErrorType() -> LoginErrorType? {
        return loginErrorType
    }
}

public struct PLLoginUseCaseOkOutput {
    public let userId: Int
    public let loginImage: String?
    public let passwordMaskEnabled: Bool?
    public let passwordMask: Int?
    public let defaultChallenge: LoginChallengeEntity
    public let trustedComputerData: TrustedComputerEntity?
}
