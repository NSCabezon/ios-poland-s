//
//  PLSmsAuthPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import DomainCommon
import Commons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter
import Security
import os

protocol PLSmsAuthPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLSmsAuthViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func authenticate(smsCode: String)
    func didSelectLoginRestartAfterTimeOut()
    func goToDeviceTrustDeviceData()
}

enum EncryptionError: Error {
    case emptyPublicKey
    case publicKeyGenerationFailed
}

final class PLSmsAuthPresenter {
    weak var view: PLSmsAuthViewProtocol?
    weak var loginManager: PLLoginLayersManagerDelegate?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }

    private var getPersistedPubKeyUseCase: PLGetPersistedPubKeyUseCase {
        self.dependenciesResolver.resolve(for: PLGetPersistedPubKeyUseCase.self)
    }

    private var authenticateInitUseCase: PLAuthenticateInitUseCase {
        self.dependenciesResolver.resolve(for: PLAuthenticateInitUseCase.self)
    }

    private var authenticateUseCase: PLAuthenticateUseCase {
        self.dependenciesResolver.resolve(for: PLAuthenticateUseCase.self)
    }

    private var encryptPasswordUseCase: PLPasswordEncryptionUseCase {
        self.dependenciesResolver.resolve(for: PLPasswordEncryptionUseCase.self)
    }

    private var globalPositionOptionUseCase: PLGetGlobalPositionOptionUseCase {
        return self.dependenciesResolver.resolve(for: PLGetGlobalPositionOptionUseCase.self)
    }

    private var getNextSceneUseCase: PLGetLoginNextSceneUseCase {
        return self.dependenciesResolver.resolve(for: PLGetLoginNextSceneUseCase.self)
    }
}

extension PLSmsAuthPresenter: PLSmsAuthPresenterProtocol {
    func didSelectLoginRestartAfterTimeOut() {
        // TODO
    }

    func viewDidLoad() {
        self.doAuthenticateInit()
    }

    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
    }

    func authenticate(smsCode: String) {
        self.doAuthenticate(smscode: smsCode)
    }

    func recoverPasswordOrNewRegistration() {
        // TODO
    }

    func didSelectChooseEnvironment() {
        // TODO
    }

    func goToDeviceTrustDeviceData() {
        self.coordinator.goToDeviceTrustDeviceData()
    }
}

//MARK: - Private Methods
private extension  PLSmsAuthPresenter {
    var coordinator: PLSmsAuthCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLSmsAuthCoordinatorProtocol.self)
    }

    func doAuthenticateInit() {
        let caseInput: PLAuthenticateInitUseCaseInput = PLAuthenticateInitUseCaseInput(userId: loginConfiguration.userIdentifier, challenge: loginConfiguration.challenge)
        Scenario(useCase: self.authenticateInitUseCase, input: caseInput)
            .execute(on: self.dependenciesResolver.resolve())
            .onError { error in
                os_log("❌ [LOGIN][Authenticate Init] Error with init SMS: %@", log: .default, type: .error, error.localizedDescription)
            }
    }

    func doAuthenticate(smscode: String) {
        guard let password = loginConfiguration.password else {
            // TODO: generate generic error, password can't be empty
            os_log("❌ [LOGIN][Authenticate] Mandatory field password is empty", log: .default, type: .error)
            return
        }

        Scenario(useCase: self.getPersistedPubKeyUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: {  [weak self] (pubKeyOutput) -> Scenario<PLPasswordEncryptionUseCaseInput, PLPasswordEncryptionUseCaseOutput, PLAuthenticateUseCaseErrorOutput>? in
                guard let self = self else { return nil}
                let encrytionKey = EncryptionKeyEntity(modulus: pubKeyOutput.modulus, exponent: pubKeyOutput.exponent)
                let useCaseInput = PLPasswordEncryptionUseCaseInput(plainPassword: password, encryptionKey: encrytionKey)
                return Scenario(useCase: self.encryptPasswordUseCase, input: useCaseInput)
            })
            .then(scenario: {  [weak self] (encryptedPasswordOutput) -> Scenario<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLAuthenticateUseCaseErrorOutput>? in
                guard let self = self else { return nil}
                let secondFactorAuthentity = SecondFactorDataAuthenticationEntity(challenge: self.loginConfiguration.challenge, value: smscode)
                let useCaseInput = PLAuthenticateUseCaseInput(encryptedPassword: encryptedPasswordOutput.encryptedPassword, userId: self.loginConfiguration.userIdentifier, secondFactorData: secondFactorAuthentity)
                return Scenario(useCase: self.authenticateUseCase, input: useCaseInput)
            })
            .then(scenario: {  [weak self] _ -> Scenario<Void, PLGetLoginNextSceneUseCaseOkOutput, PLAuthenticateUseCaseErrorOutput>? in
                guard let self = self else { return nil}
                return Scenario(useCase: self.getNextSceneUseCase)
            })
            .onSuccess({ [weak self] nextSceneResult in
                guard let self = self else { return }
                switch nextSceneResult.nextScene {
                case .trustedDeviceScene:
                    self.goToDeviceTrustDeviceData()
                case .globalPositionScene:
                    self.getGlobalPositionTypeAndNavigate()
                }
            })
            .onError { error in
                // TODO: Present errorsecondFactorData
                os_log("❌ [LOGIN][Authenticate] Login authorization did fail: %@", log: .default, type: .error, error.getErrorDesc() ?? "unknown error")
            }
    }

    func getGlobalPositionTypeAndNavigate() {
        Scenario(useCase: self.globalPositionOptionUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess( { [weak self] output in
                guard let self = self else { return }
                self.goToGlobalPosition(output.globalPositionOption)
            })
            .onError { [weak self] _ in
                guard let self = self else { return }
                self.goToGlobalPosition(.classic)
            }
    }

    func goToGlobalPosition(_ option: GlobalPositionOptionEntity) {
        let coordinatorDelegate: PLLoginCoordinatorProtocol = self.dependenciesResolver.resolve(for: PLLoginCoordinatorProtocol.self)
        self.view?.dismissLoading()
        coordinatorDelegate.goToPrivate(option)
    }
}
