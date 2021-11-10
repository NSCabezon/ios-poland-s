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

final class PLRememberedLoginProcessUseCase {
    var dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    private var loginUseCase: PLLoginUseCase {
        self.dependenciesEngine.resolve(for: PLLoginUseCase.self)
    }
    
    private var setDemoUserUseCase: PLSetDemoUserUseCase {
        return PLSetDemoUserUseCase(dependenciesResolver: self.dependenciesEngine)
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

    private var getCertificateUseCase: PLGetSecIdentityUseCase {
        self.dependenciesEngine.resolve(for: PLGetSecIdentityUseCase.self)
    }

    private var getStoredUserKey: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase {
        self.dependenciesEngine.resolve(for: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase.self)
    }

    private var getStoredTrustedDeviceHeaders: PLTrustedDeviceGetHeadersUseCase {
        self.dependenciesEngine.resolve(for: PLTrustedDeviceGetHeadersUseCase.self)
    }

    private var authorizationDataEncryptionUseCase: PLLoginAuthorizationDataEncryptionUseCase {
        self.dependenciesEngine.resolve(for: PLLoginAuthorizationDataEncryptionUseCase.self)
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
                                      rememberedLoginType: RememberedLoginType,
                                      onSuccess: @escaping (RememberedLoginConfiguration) -> Void,
                                      onFailure: @escaping (UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>, RememberedLoginConfiguration) -> Void) {
        var identity: SecIdentity?
        var encryptedStoredUserKey: String?
        let identification = configuration.userIdentifier
        let demoUserInput = PLSetDemoUserUseCaseInput(userId: identification)
        Scenario(useCase: setDemoUserUseCase, input: demoUserInput)
            .execute(on: self.dependenciesEngine.resolve())
            .then(scenario: { (_) ->Scenario<PLLoginUseCaseInput, PLLoginUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> in
                let caseInput = PLLoginUseCaseInput(userId: identification, userAlias: nil)
                return Scenario(useCase: self.loginUseCase, input: caseInput)
            })
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

                switch rememberedLoginType {
                case .Pin(value: _):
                    encryptedStoredUserKey = output.encryptedUserKeyPIN
                case .Biometrics:
                    encryptedStoredUserKey = output.encryptedUserKeyBiometrics
                }
                return Scenario(useCase: self.getStoredTrustedDeviceHeaders)
            })
            .then(scenario: { [weak self] output ->Scenario<PLLoginAuthorizationDataEncryptionUseCaseInput, PLLoginAuthorizationDataEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self,
                      let challengeValue = configuration.challenge?.value,
                      let privateKey = identity?.privateKey,
                      let encryptedStoredUserKey = encryptedStoredUserKey,
                      let appId = output.appId,
                      let randomKey = Self.getSoftwareTokenKey(for: rememberedLoginType, with: configuration)?.randomKey
                else { onFailure(.error(PLUseCaseErrorOutput(errorDescription: "Missing value")), configuration); return nil }

                let pin = Self.getPinIfNecessary(from: rememberedLoginType)
                let caseInput = PLLoginAuthorizationDataEncryptionUseCaseInput(appId: appId,
                                                                               pin: pin,
                                                                               encryptedUserKey: encryptedStoredUserKey,
                                                                               randomKey: randomKey,
                                                                               challenge: challengeValue,
                                                                               privateKey: privateKey)
                return Scenario(useCase: self.authorizationDataEncryptionUseCase, input: caseInput)
            })
            .then(scenario: { [weak self] output ->Scenario<PLRememberedLoginConfirmChallengeUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self,
                      let softwareTokenType = Self.getSoftwareTokenKey(for: rememberedLoginType, with: configuration)?.softwareTokenType,
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
                if let authType = configuration.challenge?.authorizationType, authType != .softwareToken {
                    let manager: PLManagersProviderProtocol = self.dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
                    manager.getTrustedDeviceManager().deleteTrustedDeviceHeaders()
                }
            }
    }
}

private extension PLRememberedLoginProcessUseCase {

    static func getSoftwareTokenKey(for rememberedLoginType: RememberedLoginType, with configuration: RememberedLoginConfiguration) -> PLRememberedLoginSoftwareTokenKeys? {
        switch rememberedLoginType {
        case .Pin(_):
            return configuration.pendingChallenge?.getSoftwareTokenKey(for: .PIN)
        case .Biometrics:
            return configuration.pendingChallenge?.getSoftwareTokenKey(for: .BIOMETRICS)
        }
    }

    static func getPinIfNecessary(from rememberedLoginType: RememberedLoginType) -> String? {
        switch rememberedLoginType {
        case .Pin(let value):
            return value
        default:
            return nil
        }
    }
}
