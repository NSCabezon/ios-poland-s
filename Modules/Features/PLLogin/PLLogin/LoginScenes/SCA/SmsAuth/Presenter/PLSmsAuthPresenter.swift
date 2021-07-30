//
//  PLSmsAuthPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import DomainCommon
import Commons
import PLCommons
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

    private var authenticateInitUseCase: PLAuthenticateInitUseCase {
        self.dependenciesResolver.resolve(for: PLAuthenticateInitUseCase.self)
    }

    private var globalPositionOptionUseCase: PLGetGlobalPositionOptionUseCase {
        return self.dependenciesResolver.resolve(for: PLGetGlobalPositionOptionUseCase.self)
    }
    
    private var authProcessUseCase: PLAuthProcessUseCase {
        self.dependenciesResolver.resolve(for: PLAuthProcessUseCase.self)
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
        self.view?.dismissLoading()
        self.coordinator.goToDeviceTrustDeviceData()
    }
}

//MARK: - Private Methods
private extension  PLSmsAuthPresenter {
    var coordinator: PLScaAuthCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLScaAuthCoordinatorProtocol.self)
    }

    func doAuthenticateInit() {        
        let caseInput: PLAuthenticateInitUseCaseInput = PLAuthenticateInitUseCaseInput(userId: loginConfiguration.userIdentifier, challenge: loginConfiguration.challenge)
        Scenario(useCase: self.authenticateInitUseCase, input: caseInput)
            .execute(on: self.dependenciesResolver.resolve())
            .onError { [weak self] error in
                self?.handleError(error)
            }
    }

    func doAuthenticate(smscode: String) {
        guard let password = loginConfiguration.password else {
            self.handle(error: .applicationNotWorking)
            os_log("❌ [LOGIN][Authenticate] Mandatory field password is empty", log: .default, type: .error)
            return
        }
        let authProcessInput = PLAuthProcessInput(scaCode: smscode,
                                                  password: password,
                                                  userId: loginConfiguration.userIdentifier,
                                                  challenge: loginConfiguration.challenge)
        authProcessUseCase.execute(input: authProcessInput) { [weak self]  nextSceneResult in
            guard let self = self else { return }
            switch nextSceneResult.nextScene {
            case .trustedDeviceScene:
                self.goToDeviceTrustDeviceData()
            case .globalPositionScene:
                self.getGlobalPositionTypeAndNavigate()
            }
        } onFailure: { [weak self]  error in
            self?.handleError(error)
        }
    }

    func getGlobalPositionTypeAndNavigate() {
        Scenario(useCase: self.globalPositionOptionUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess( { [weak self] output in
                self?.goToGlobalPosition(output.globalPositionOption)
            })
            .onError { [weak self] _ in
                self?.goToGlobalPosition(.classic)
            }
    }
    
    func goBack() {
        coordinator.goToUnrememberedLogindScene()
    }

    func goToGlobalPosition(_ option: GlobalPositionOptionEntity) {
        view?.dismissLoading()
        coordinator.goToGlobalPositionScene(option)
    }
}

extension PLSmsAuthPresenter: PLGenericErrorPresenterLayerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        self.goBack()
    }
}

private extension PLSmsAuthPresenter {
    
    // MARK: Auxiliar methods
    func handleError(_ error: UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>?) {
        os_log("❌ [LOGIN][Authenticate] Login authorization did fail: %@", log: .default, type: .error, error?.getErrorDesc() ?? "unknown error")
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
