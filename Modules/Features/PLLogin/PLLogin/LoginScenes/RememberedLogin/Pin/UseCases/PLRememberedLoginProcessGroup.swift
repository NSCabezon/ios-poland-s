//
//  PLRememberedLoginProcessGroup.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 19/10/21.
//

import Foundation
import Commons
import PLCommons
import SANPLLibrary
import PLCryptography
import DomainCommon

final class PLRememberedLoginProcessGroup: ProcessGroup <PLRememberedLoginProcessGroupInput, PLRememberedLoginProcessGroupOutput, PLRememberedLoginProcessGroupError> {

    private var loginUseCase: PLLoginUseCase {
        self.dependenciesEngine.resolve(for: PLLoginUseCase.self)
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

    private var getCertificateUseCase: PLGetSecIdentityUseCase<LoginErrorType> {
        self.dependenciesEngine.resolve(for: PLGetSecIdentityUseCase<LoginErrorType>.self)
    }

    private var getStoredUserKey: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase<LoginErrorType> {
        self.dependenciesEngine.resolve(for: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase<LoginErrorType>.self)
    }

    private var getStoredTrustedDeviceHeaders: PLTrustedDeviceGetHeadersUseCase<LoginErrorType> {
        self.dependenciesEngine.resolve(for: PLTrustedDeviceGetHeadersUseCase<LoginErrorType>.self)
    }

    private var authorizationDataEncryptionUseCase: PLAuthorizationDataEncryptionUseCase<LoginErrorType> {
        self.dependenciesEngine.resolve(for: PLAuthorizationDataEncryptionUseCase<LoginErrorType>.self)
    }

    override func registerDependencies() {
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
        self.dependenciesEngine.register(for: PLGetSecIdentityUseCase<LoginErrorType>.self) {_  in
            return PLGetSecIdentityUseCase<LoginErrorType>()
        }
        self.dependenciesEngine.register(for: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase<LoginErrorType>.self) { resolver in
            return PLTrustedDeviceGetStoredEncryptedUserKeyUseCase<LoginErrorType>(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLTrustedDeviceGetHeadersUseCase<LoginErrorType>.self) { resolver in
            return PLTrustedDeviceGetHeadersUseCase<LoginErrorType>(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLAuthorizationDataEncryptionUseCase<LoginErrorType>.self) { resolver in
            return PLAuthorizationDataEncryptionUseCase<LoginErrorType>(dependenciesResolver: resolver)
        }
    }

    override func execute(input: PLRememberedLoginProcessGroupInput,
                          completion: @escaping (Result<PLRememberedLoginProcessGroupOutput, PLRememberedLoginProcessGroupError>) -> Void) {
        var identity: SecIdentity?
        var encryptedStoredUserKey: String?
        let identification = input.configuration.userIdentifier
        let caseInput = PLLoginUseCaseInput(userId: identification, userAlias: nil)
        Scenario(useCase: loginUseCase, input: caseInput)
            .execute(on: self.dependenciesEngine.resolve())
            .then(scenario: { [weak self] output ->Scenario<PLAuthenticateInitUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                input.configuration.challenge = output.secondFactorData.defaultChallenge
                input.configuration.secondFactorDataFinalState = output.secondFactorFinalState
                input.configuration.unblockRemainingTimeInSecs = output.unblockRemainingTimeInSecs
                let caseInput = PLAuthenticateInitUseCaseInput(userId: identification,
                                                               challenge: output.secondFactorData.defaultChallenge)
                return Scenario(useCase: self.authenticateInitUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] output ->Scenario<PLRememberedLoginPendingChallengeUseCaseInput, PLRememberedLoginPendingChallenge, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }

                let caseInput = PLRememberedLoginPendingChallengeUseCaseInput(userId: identification)
                return Scenario(useCase: self.pendingChallengeUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] pendingChallenge ->Scenario<PLGetSecIdentityUseCaseInput, PLGetSecIdentityUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }

                input.configuration.pendingChallenge = pendingChallenge
                let caseInput = PLGetSecIdentityUseCaseInput(label: PLConstants.certificateIdentityLabel)
                return Scenario(useCase: self.getCertificateUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] output ->Scenario<Void, PLTrustedDeviceGetStoredEncryptedUserKeyUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }

                identity = output.secIdentity
                return Scenario(useCase: self.getStoredUserKey)
            })
            .then(scenario: { [weak self] output ->Scenario<Void, PLTrustedDeviceGetHeadersUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }

                switch input.accessType {
                case .pin(value: _):
                    encryptedStoredUserKey = output.encryptedUserKeyPIN
                case .biometrics:
                    encryptedStoredUserKey = output.encryptedUserKeyBiometrics
                }
                return Scenario(useCase: self.getStoredTrustedDeviceHeaders)
            })
            .then(scenario: { [weak self] output ->Scenario<PLAuthorizationDataEncryptionUseCaseInput, PLAuthorizationDataEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self,
                      let challengeValue = input.configuration.challenge?.value,
                      let privateKey = identity?.privateKey,
                      let encryptedStoredUserKey = encryptedStoredUserKey,
                      let appId = output.appId,
                let randomKey = Self.getSoftwareTokenKey(for: input.accessType, with: input.configuration)?.randomKey
                else {
                    completion(.failure(PLRememberedLoginProcessGroupError(error: .error(PLUseCaseErrorOutput(errorDescription: "Missing value")),
                                                                           configuration: input.configuration)))
                    return nil

                }

                let pin = Self.getPinIfNecessary(from: input.accessType)
                let caseInput = PLAuthorizationDataEncryptionUseCaseInput(appId: appId,
                                                                          pin: pin,
                                                                          encryptedUserKey: encryptedStoredUserKey,
                                                                          randomKey: randomKey,
                                                                          challenge: challengeValue,
                                                                          privateKey: privateKey,
                                                                          isDemoUser: input.configuration.isDemoUser)
                return Scenario(useCase: self.authorizationDataEncryptionUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] output ->Scenario<PLRememberedLoginConfirmChallengeUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self,
                      let softwareTokenType = Self.getSoftwareTokenKey(for: input.accessType,
                                                                       with: input.configuration)?.softwareTokenType,
                      let certificate = identity?.PEMFormattedCertificate()
                else {
                    completion(.failure(PLRememberedLoginProcessGroupError(error: .error(PLUseCaseErrorOutput(errorDescription: "Missing value")),
                                                                           configuration: input.configuration)))
                     return nil
                }

                let authorizationId = String(describing: input.configuration.pendingChallenge?.authorizationId)
                let caseInput = PLRememberedLoginConfirmChallengeUseCaseInput(userId: identification,
                                                                              authorizationId: authorizationId,
                                                                              softwareTokenType: softwareTokenType,
                                                                              trustedDeviceCertificate: certificate,
                                                                              authorizationData: output.encryptedAuthorizationData)
                return Scenario(useCase: self.confirmChallengeUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] Void ->Scenario<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self,
                      let challenge = input.configuration.challenge
                else {
                    completion(.failure(PLRememberedLoginProcessGroupError(error: .error(PLUseCaseErrorOutput(errorDescription: "Missing value")),
                                                                           configuration: input.configuration)))
                     return nil
                }

                let authEntity = SecondFactorDataAuthenticationEntity(challenge: challenge, value: "")
                let caseInput = PLAuthenticateUseCaseInput(encryptedPassword: nil,
                                                           userId: identification,
                                                           secondFactorData: authEntity)
                return Scenario(useCase: self.authenticateUseCase, input: caseInput)
            })
            .onSuccess { output in
                completion(.success(PLRememberedLoginProcessGroupOutput(configuration: input.configuration)))
            }
            .onError { error in
                completion(.failure(PLRememberedLoginProcessGroupError(error: error,
                                                                       configuration: input.configuration)))
            }
            .finally { [weak self] in
                guard let self = self else { return }
                guard input.configuration.isDemoUser == false else { return }
                if let authType = input.configuration.challenge?.authorizationType, authType != .softwareToken {
                    let manager: PLManagersProviderProtocol = self.dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
                    manager.getTrustedDeviceManager().deleteTrustedDeviceHeaders()
                }
            }
    }
}

private extension PLRememberedLoginProcessGroup {

    static func getSoftwareTokenKey(for accessType: AccessType, with configuration: RememberedLoginConfiguration) -> PLRememberedLoginSoftwareTokenKeys? {
        switch accessType {
        case .pin(_):
            return configuration.pendingChallenge?.getSoftwareTokenKey(for: .PIN)
        case .biometrics:
            return configuration.pendingChallenge?.getSoftwareTokenKey(for: .BIOMETRICS)
        }
    }

    static func getPinIfNecessary(from accessType: AccessType) -> String? {
        switch accessType {
        case .pin(let value):
            return value
        default:
            return nil
        }
    }
}

public struct PLRememberedLoginProcessGroupInput {
    let configuration: RememberedLoginConfiguration
    let accessType: AccessType
}

public struct PLRememberedLoginProcessGroupOutput {
    let configuration: RememberedLoginConfiguration
}

public struct PLRememberedLoginProcessGroupError: Error {
    let error: UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>
    let configuration: RememberedLoginConfiguration
}
