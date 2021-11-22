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

final class PLAuthProcessGroup: ProcessGroup<PLAuthProcessGroupInput, PLAuthProcessGroupOutput, PLAuthProcessGroupError> {
    private var onContinue: ((Result<PLAuthProcessGroupOutput, PLAuthProcessGroupError>) -> Void)?
    private var nextScene: PLUnrememberedLoginNextScene = .globalPositionScene

    private var persistedPubKeyUseCase: PLGetPersistedPubKeyUseCase {
        self.dependenciesResolver.resolve(for: PLGetPersistedPubKeyUseCase.self)
    }

    private var authenticateUseCase: PLAuthenticateUseCase {
        self.dependenciesResolver.resolve(for: PLAuthenticateUseCase.self)
    }

    private var encryptPasswordUseCase: PLPasswordEncryptionUseCase {
        self.dependenciesResolver.resolve(for: PLPasswordEncryptionUseCase.self)
    }

    private var getNextSceneUseCase: PLGetLoginNextSceneUseCase {
        return self.dependenciesResolver.resolve(for: PLGetLoginNextSceneUseCase.self)
    }

    private var appRepository:AppRepositoryProtocol {
        self.dependenciesResolver.resolve(for: AppRepositoryProtocol.self)
    }

    private var bsanManagersProvider:BSANManagersProvider  {
        self.dependenciesResolver.resolve(for: BSANManagersProvider.self)
    }

    private lazy var sessionDataManager: SessionDataManager = {
        let manager = self.dependenciesResolver.resolve(for: SessionDataManager.self)
        manager.setDataManagerProcessDelegate(self)
        return manager
    }()

    override func execute(input: PLAuthProcessGroupInput, completion: @escaping (Result<PLAuthProcessGroupOutput, PLAuthProcessGroupError>) -> Void) {
        let secondFactorAuthentity = SecondFactorDataAuthenticationEntity(challenge: input.challenge,
                                                                          value: input.scaCode)
        self.onContinue = completion
        Scenario(useCase: self.persistedPubKeyUseCase)
            .execute(on: self.dependenciesResolver.resolve())
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
                guard let self = self else { return }
                self.nextScene = nextSceneResult.nextScene
                self.storePersistedUser(input: input)
            })
            .onError { error in
                completion(.failure(PLAuthProcessGroupError(useCaseError: error)))
            }
    }

    private func storePersistedUser(input: PLAuthProcessGroupInput) {
        let bsanEnv: BSANEnvironmentDTO?
        do {
            bsanEnv = try self.bsanManagersProvider.getBsanEnvironmentsManager().getCurrentEnvironment().getResponseData()
        } catch {
            self.onContinue?(.success(PLAuthProcessGroupOutput(nextScene: self.nextScene)))
            self.onContinue = nil
            return
        }

        let dto = PersistedUserDTO.createPersistedUser(loginType: .U, login: input.userId, environmentName: bsanEnv?.name ?? "")
        _ = self.appRepository.setPersistedUserDTO(persistedUserDTO:dto)
        sessionDataManager.load()
    }
}

extension PLAuthProcessGroup: SessionDataManagerProcessDelegate {
    func handleProcessEvent(_ event: SessionManagerProcessEvent) {
        switch event {
        case .loadDataSuccess, .fail(_):
            self.onContinue?(.success(PLAuthProcessGroupOutput(nextScene: self.nextScene)))
            self.onContinue = nil

        default:
            break
        }
    }
}

// MARK: I/O types definition
struct PLAuthProcessGroupInput {
    let scaCode, password, userId: String
    let challenge: ChallengeEntity
}

struct PLAuthProcessGroupOutput {
    let nextScene: PLUnrememberedLoginNextScene
}

struct PLAuthProcessGroupError: Error {
    let useCaseError: UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>
}

