//
//  PLAuthProcessUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 29/7/21.
//

import Commons
import DomainCommon
import SANPLLibrary
import SANLegacyLibrary
import Repository
import Models
import PLCommons

final class PLAuthProcessUseCase {
    var dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    private var onContinue: ((PLGetLoginNextSceneUseCaseOkOutput) -> Void)?
    private var nextScene = PLGetLoginNextSceneUseCaseOkOutput(nextScene: .globalPositionScene)

    private var persistedPubKeyUseCase: PLGetPersistedPubKeyUseCase {
        self.dependenciesEngine.resolve(for: PLGetPersistedPubKeyUseCase.self)
    }
    
    private var authenticateUseCase: PLAuthenticateUseCase {
        self.dependenciesEngine.resolve(for: PLAuthenticateUseCase.self)
    }
    
    private var encryptPasswordUseCase: PLPasswordEncryptionUseCase {
        self.dependenciesEngine.resolve(for: PLPasswordEncryptionUseCase.self)
    }
    
    private var getNextSceneUseCase: PLGetLoginNextSceneUseCase {
        return self.dependenciesEngine.resolve(for: PLGetLoginNextSceneUseCase.self)
    }
    
    private var appRepository:AppRepositoryProtocol {
        self.dependenciesEngine.resolve(for: AppRepositoryProtocol.self)
    }
    
    private var bsanManagersProvider:BSANManagersProvider  {
        self.dependenciesEngine.resolve(for: BSANManagersProvider.self)
    }
    
    private lazy var sessionProcessHelper: SessionProcessHelperProtocol = {
        let sessionProcess = self.dependenciesEngine.resolve(for: SessionProcessHelperProtocol.self)
        sessionProcess.setSessionProcessDelegate(self)
        return sessionProcess
    }()

    public init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
        
        self.dependenciesEngine.register(for: PLAuthenticateUseCase.self) { resolver in
            return PLAuthenticateUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLPasswordEncryptionUseCase.self) { resolver in
           return PLPasswordEncryptionUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLGetPersistedPubKeyUseCase.self) { resolver in
           return PLGetPersistedPubKeyUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLGetLoginNextSceneUseCase.self) { resolver in
            return PLGetLoginNextSceneUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLSessionUseCase.self) { resolver in
            return PLSessionUseCase(dependenciesResolver: resolver)
        }
    }
    
    public func execute(input: PLAuthProcessInput,
                        onSuccess: @escaping (PLGetLoginNextSceneUseCaseOkOutput) -> Void,
                        onFailure: @escaping (UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>) -> Void) {
        
        let secondFactorAuthentity = SecondFactorDataAuthenticationEntity(challenge: input.challenge,
                                                                          value: input.scaCode)
        self.onContinue = onSuccess
        Scenario(useCase: self.persistedPubKeyUseCase)
            .execute(on: self.dependenciesEngine.resolve())
            .then(scenario: {  [weak self] (pubKeyOutput) -> Scenario<PLPasswordEncryptionUseCaseInput, PLPasswordEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                let encrytionKey = EncryptionKeyEntity(modulus: pubKeyOutput.modulus, exponent: pubKeyOutput.exponent)
                let useCaseInput = PLPasswordEncryptionUseCaseInput(plainPassword: input.password,
                                                                    encryptionKey: encrytionKey)
                return Scenario(useCase: self.encryptPasswordUseCase, input: useCaseInput)
            })
            .then(scenario: {  [weak self] (encryptedPasswordOutput) -> Scenario<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }

                let useCaseInput = PLAuthenticateUseCaseInput(encryptedPassword: encryptedPasswordOutput.encryptedPassword,
                                                              userId: input.userId,
                                                              secondFactorData: secondFactorAuthentity)
                
                return Scenario(useCase: self.authenticateUseCase, input: useCaseInput)
            })
            .then(scenario: { [weak self] _ -> Scenario<Void, PLGetLoginNextSceneUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                return Scenario(useCase: self.getNextSceneUseCase)
            })
            .onSuccess({ [weak self] nextSceneResult in
                self?.nextScene = nextSceneResult
                self?.storePersistedUser(input: input)
            })
            .onError { error in
                onFailure(error)
            }
    }
    
    private func storePersistedUser(input: PLAuthProcessInput) {
        let bsanEnv: BSANEnvironmentDTO?
        do {
            bsanEnv = try self.bsanManagersProvider.getBsanEnvironmentsManager().getCurrentEnvironment().getResponseData()
        } catch {
            self.onContinue?(self.nextScene)
            return
        }
        
        let dto = PersistedUserDTO.createPersistedUser(loginType: .U, login: input.userId, environmentName: bsanEnv?.name ?? "")
        _ = self.appRepository.setPersistedUserDTO(persistedUserDTO:dto)
        sessionProcessHelper.loadSessionData()
    }
}

extension PLAuthProcessUseCase: SessionProcessHelperDelegate {
    func handle(event: SessionProcessEvent) {
        switch event {
        case .loadDataSuccess, .fail(_):
            self.onContinue?(self.nextScene)
        default:
            break
        }
    }
}

// MARK: I/O types definition
struct PLAuthProcessInput {
    let scaCode, password, userId: String
    let challenge: ChallengeEntity
}
