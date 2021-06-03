//
//  PLAuthenticateUseCase.swift
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

final class PLAuthenticateUseCase: UseCase<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLAuthenticateUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLAuthenticateUseCaseInput) throws -> UseCaseResponse<PLAuthenticateUseCaseOkOutput, PLAuthenticateUseCaseErrorOutput> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let parameters = AuthenticateParameters(encryptedPassword: requestValues.encryptedPassword, userId: requestValues.userId, secondFactorData: SecondFactorDataAuthenticate(response: Response(challenge: Challenge(authorizationType: requestValues.secondFactorData.challenge.authorizationType, value: requestValues.secondFactorData.challenge.value), value: requestValues.secondFactorData.value)))
        let result = try managerProvider.getLoginManager().doAuthenticate(parameters)
        switch result {
        case .success(let authenticateData):
            let uthenticateOutput = PLAuthenticateUseCaseOkOutput(userId: authenticateData.userId, userCif: authenticateData.userCif, expires: authenticateData.expires, expires_in: authenticateData.expires_in, companyContext: authenticateData.companyContext, trusted_device_token: authenticateData.trusted_device_token, type: authenticateData.type, access_token: authenticateData.access_token, client_id: authenticateData.client_id)
            return UseCaseResponse.ok(uthenticateOutput)
        case .failure(_):
                // TODO: the error management will be implemented in next sprint.
                return UseCaseResponse.error(PLAuthenticateUseCaseErrorOutput(loginErrorType: .unauthorized))
        }
    }
}

private extension PLAuthenticateUseCase {
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

extension PLAuthenticateUseCase: Cancelable {
    public func cancel() {}
}

// MARK: I/O types definition
struct PLAuthenticateUseCaseInput {
    let encryptedPassword, userId: String
    let secondFactorData: SecondFactorDataAuthenticationEntity
}

final class PLAuthenticateUseCaseErrorOutput: StringErrorOutput {
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

public struct PLAuthenticateUseCaseOkOutput {
    public let userId, userCif, expires, expires_in: Int
    public let companyContext, trusted_device_token: Bool
    public let type, access_token, client_id: String
}
