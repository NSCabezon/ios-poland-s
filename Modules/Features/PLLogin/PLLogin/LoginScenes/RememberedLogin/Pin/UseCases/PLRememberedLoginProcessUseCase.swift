//
//  PLRememberedLoginProcessUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 19/10/21.
//

import Foundation
import Commons
import PLCommons
import SANPLLibrary
import DomainCommon

final class PLRememberedLoginProcessUseCase {
    var dependenciesEngine: DependenciesResolver & DependenciesInjector
    
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

    public init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
        
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
    }
    
    public func executePersistedLogin(configuration: RememberedLoginConfiguration,
                                      accessType: AccessType,
                                      onSuccess: @escaping (RememberedLoginConfiguration) -> Void,
                                      onFailure: @escaping (UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>, RememberedLoginConfiguration) -> Void) {
        var identity: SecIdentity?
        var encryptedStoredUserKey: String?
        let identification = configuration.userIdentifier
        let caseInput = PLLoginUseCaseInput(userId: identification, userAlias: nil)
        Scenario(useCase: loginUseCase, input: caseInput)
            .execute(on: self.dependenciesEngine.resolve())
            .then(scenario: { [weak self] output ->Scenario<PLAuthenticateInitUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                configuration.challenge = output.secondFactorData.defaultChallenge
                configuration.secondFactorDataFinalState = output.secondFactorFinalState
                configuration.unblockRemainingTimeInSecs = output.unblockRemainingTimeInSecs
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

                configuration.pendingChallenge = pendingChallenge
                let caseInput = PLGetSecIdentityUseCaseInput(label: PLLoginConstants.certificateIdentityLabel)
                return Scenario(useCase: self.getCertificateUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] output ->Scenario<Void, PLTrustedDeviceGetStoredEncryptedUserKeyUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { onFailure(.error(PLUseCaseErrorOutput(errorDescription: "Missing value")), configuration); return nil }

                identity = output.secIdentity
                return Scenario(useCase: self.getStoredUserKey)
            })
            .then(scenario: { [weak self] output ->Scenario<Void, PLTrustedDeviceGetHeadersUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { onFailure(.error(PLUseCaseErrorOutput(errorDescription: "Missing value")), configuration); return nil }

                switch accessType {
                case .pin(value: _):
                    encryptedStoredUserKey = output.encryptedUserKeyPIN
                case .biometrics:
                    encryptedStoredUserKey = output.encryptedUserKeyBiometrics
                }
                return Scenario(useCase: self.getStoredTrustedDeviceHeaders)
            })
            .then(scenario: { [weak self] output ->Scenario<PLAuthorizationDataEncryptionUseCaseInput, PLAuthorizationDataEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self,
                      let challengeValue = configuration.challenge?.value,
                      let privateKey = identity?.privateKey,
                      let encryptedStoredUserKey = encryptedStoredUserKey,
                      let appId = output.appId,
                      let randomKey = Self.getSoftwareTokenKey(for: accessType, with: configuration)?.randomKey
                else { onFailure(.error(PLUseCaseErrorOutput(errorDescription: "Missing value")), configuration); return nil }

                let pin = Self.getPinIfNecessary(from: accessType)
                let caseInput = PLAuthorizationDataEncryptionUseCaseInput(appId: appId,
                                                                               pin: pin,
                                                                               encryptedUserKey: encryptedStoredUserKey,
                                                                               randomKey: randomKey,
                                                                               challenge: challengeValue,
                                                                               privateKey: privateKey,
                                                                               isDemoUser: configuration.isDemoUser)
                return Scenario(useCase: self.authorizationDataEncryptionUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] output ->Scenario<PLRememberedLoginConfirmChallengeUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self,
                      let softwareTokenType = Self.getSoftwareTokenKey(for: accessType, with: configuration)?.softwareTokenType,
                      let certificate = identity?.PEMFormattedCertificate() else { onFailure(.error(PLUseCaseErrorOutput(errorDescription: "Missing value")), configuration); return nil }

                let authorizationId = String(describing: configuration.pendingChallenge?.authorizationId)
                let caseInput = PLRememberedLoginConfirmChallengeUseCaseInput(userId: identification,
                                                                              authorizationId: authorizationId,
                                                                              softwareTokenType: softwareTokenType,
                                                                              trustedDeviceCertificate: certificate,
                                                                              authorizationData: output.encryptedAuthorizationData)
                return Scenario(useCase: self.confirmChallengeUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] Void ->Scenario<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self,
                      let challenge = configuration.challenge else { onFailure(.error(PLUseCaseErrorOutput(errorDescription: "Missing value")), configuration); return nil }

                let authEntity = SecondFactorDataAuthenticationEntity(challenge: challenge, value: "")
                let caseInput = PLAuthenticateUseCaseInput(encryptedPassword: nil,
                                                           userId: identification,
                                                           secondFactorData: authEntity)
                return Scenario(useCase: self.authenticateUseCase, input: caseInput)
            })
            .onSuccess { output in
                onSuccess(configuration)
            }
            .onError { error in
                onFailure(error, configuration)
            }
            .finally { [weak self] in
                guard let self = self else { return }
                guard configuration.isDemoUser == false else { return }
                if let authType = configuration.challenge?.authorizationType, authType != .softwareToken {
                    let manager: PLManagersProviderProtocol = self.dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
                    manager.getTrustedDeviceManager().deleteTrustedDeviceHeaders()
                }
            }
    }
}

private extension PLRememberedLoginProcessUseCase {

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
