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
    
    private var authProcessUseCase: PLAuthProcessUseCase {
        self.dependenciesResolver.resolve(for: PLAuthProcessUseCase.self)
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
        self.view?.dismissLoading()
        self.coordinator.goToDeviceTrustDeviceData()
    }
    
    func doAuthenticate(token: String) {
        guard let password = loginConfiguration.password else {
            self.handle(error: .applicationNotWorking)
            os_log("❌ [LOGIN][Authenticate] Mandatory field password is empty", log: .default, type: .error)
            return
        }
        self.view?.showLoading()
        let authProcessInput = PLAuthProcessInput(scaCode: token,
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
    var coordinator: PLScaAuthCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLScaAuthCoordinatorProtocol.self)
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
        view?.dismissLoading()
        coordinator.goToGlobalPositionScene(option)
    }
    
    func goBack() {
        coordinator.goToUnrememberedLogindScene()
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
