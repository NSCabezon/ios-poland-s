//
//  PLAuthenticateInitUseCase.swift
//  Account
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import Commons
import DomainCommon
import SANPLLibrary
import Repository
import Models
import PLCommons

final class PLAuthenticateInitUseCase: UseCase<PLAuthenticateInitUseCaseInput, Void, PLAuthenticateInitUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLAuthenticateInitUseCaseInput) throws -> UseCaseResponse<Void, PLAuthenticateInitUseCaseErrorOutput> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = AuthenticateInitParameters(userId: requestValues.userId, secondFactorData: SecondFactorData(defaultChallenge: DefaultChallenge(authorizationType: requestValues.secondFactorData.defaultChallenge.authorizationType, value: requestValues.secondFactorData.defaultChallenge.value)))
        let result = try managerProvider.getLoginManager().doAuthenticateInit(parameters)
        switch result {
        case .success(_):
            // TODO: Check if userID must be a not optional Int
            return UseCaseResponse.ok()
        case .failure(_):
            // TODO: the error management will be implemented in next sprint.
            return UseCaseResponse.error(PLAuthenticateInitUseCaseErrorOutput(loginErrorType: .unauthorized))
        }
    }
}

private extension PLAuthenticateInitUseCase {
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

extension PLAuthenticateInitUseCase: Cancelable {
    public func cancel() {}
}

// MARK: I/O types definition
struct PLAuthenticateInitUseCaseInput {
    let userId: String
    let secondFactorData: SecondFactorDataEntity
}

final class PLAuthenticateInitUseCaseErrorOutput: StringErrorOutput {
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
