//
//  PLHardwareTokenPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 20/7/21.
//

import Models
import Commons
import PLCommons
import os

protocol PLHardwareTokenPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLHardwareTokenViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func goToDeviceTrustDeviceData()
    func doAuthenticate(token: String)
}

final class PLHardwareTokenPresenter {
    weak var view: PLHardwareTokenViewProtocol?
    weak var loginManager: PLLoginLayersManagerDelegate?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }

    private var globalPositionOptionUseCase: PLGetGlobalPositionOptionUseCase {
        return self.dependenciesResolver.resolve(for: PLGetGlobalPositionOptionUseCase.self)
    }

    private var getNextSceneUseCase: PLGetLoginNextSceneUseCase {
        return self.dependenciesResolver.resolve(for: PLGetLoginNextSceneUseCase.self)
    }
    
    private var authenticateUseCase: PLAuthenticateUseCase {
        self.dependenciesResolver.resolve(for: PLAuthenticateUseCase.self)
    }
    
    private var getPersistedPubKeyUseCase: PLGetPersistedPubKeyUseCase {
        self.dependenciesResolver.resolve(for: PLGetPersistedPubKeyUseCase.self)
    }
    
    private var encryptPasswordUseCase: PLPasswordEncryptionUseCase {
        self.dependenciesResolver.resolve(for: PLPasswordEncryptionUseCase.self)
    }
}

extension PLHardwareTokenPresenter: PLHardwareTokenPresenterProtocol {
    func didSelectLoginRestartAfterTimeOut() {
        // TODO
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
    }

    func goToDeviceTrustDeviceData() {
        self.coordinator.goToDeviceTrustDeviceData()
    }
    
    func doAuthenticate(token: String) {
        guard let password = loginConfiguration.password else {
            self.handle(error: .applicationNotWorking)
            os_log("❌ [LOGIN][Authenticate] Mandatory field password is empty", log: .default, type: .error)
            return
        }
        
        self.view?.showLoading()
        Scenario(useCase: self.getPersistedPubKeyUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: {  [weak self] (pubKeyOutput) -> Scenario<PLPasswordEncryptionUseCaseInput, PLPasswordEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil}
                let encrytionKey = EncryptionKeyEntity(modulus: pubKeyOutput.modulus, exponent: pubKeyOutput.exponent)
                let useCaseInput = PLPasswordEncryptionUseCaseInput(plainPassword: password, encryptionKey: encrytionKey)
                return Scenario(useCase: self.encryptPasswordUseCase, input: useCaseInput)
            })
            .then(scenario: {  [weak self] (encryptedPasswordOutput) -> Scenario<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil}
                let secondFactorAuthentity = SecondFactorDataAuthenticationEntity(challenge: self.loginConfiguration.challenge, value: token)
                let useCaseInput = PLAuthenticateUseCaseInput(encryptedPassword: encryptedPasswordOutput.encryptedPassword, userId: self.loginConfiguration.userIdentifier, secondFactorData: secondFactorAuthentity)
                return Scenario(useCase: self.authenticateUseCase, input: useCaseInput)
            })
            .then(scenario: {  [weak self] _ -> Scenario<Void, PLGetLoginNextSceneUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
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
            .onError { [weak self] error in
                self?.handleError(error)
            }
    }
}

extension PLHardwareTokenPresenter: PLGenericErrorPresenterLayerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        self.goBack()
    }
}

//MARK: - Private Methods
private extension  PLHardwareTokenPresenter {
    var coordinator: PLHardwareTokenCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLHardwareTokenCoordinatorProtocol.self)
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
    
    func goBack() {
        let coordinatorDelegate: PLLoginCoordinatorProtocol = self.dependenciesResolver.resolve(for: PLLoginCoordinatorProtocol.self)
        coordinatorDelegate.backToLogin()
    }
    
    // MARK: Auxiliar methods
    func handleError(_ error: UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>) {
        os_log("❌ [LOGIN][Authenticate] Login authorization did fail: %@", log: .default, type: .error, error.getErrorDesc() ?? "unknown error")
        switch error {
        case .error(let error):
            if error?.error == nil {
                self.handle(error: error?.genericError ?? .unknown)
            } else {
                self.handle(error: .applicationNotWorking)
            }
        case .networkUnavailable:
            self.handle(error: .noConnection)
        default:
            self.handle(error: .applicationNotWorking)
        }
    }
}
