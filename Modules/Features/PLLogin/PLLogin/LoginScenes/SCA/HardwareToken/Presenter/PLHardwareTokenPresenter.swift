//
//  PLHardwareTokenPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 20/7/21.
//

import Models
import Commons
import PLCommons
import LoginCommon
import os

protocol PLHardwareTokenPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLHardwareTokenViewProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func goToDeviceTrustDeviceData()
    func doAuthenticate(token: String)
}

final class PLHardwareTokenPresenter {
    weak var view: PLHardwareTokenViewProtocol?
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

    private var sessionUseCase: PLSessionUseCase {
        self.dependenciesResolver.resolve(for: PLSessionUseCase.self)
    }

    private var notificationGetTokenAndRegisterUseCase: PLGetNotificationTokenAndRegisterUseCase {
        return self.dependenciesResolver.resolve(for: PLGetNotificationTokenAndRegisterUseCase.self)
    }
}

extension PLHardwareTokenPresenter: PLHardwareTokenPresenterProtocol {
    func didSelectLoginRestartAfterTimeOut() {
        // TODO
    }

    func viewDidLoad() {
        self.trackScreen()
    }

    func viewWillAppear() {
    }

    func goToDeviceTrustDeviceData() {
        self.view?.dismissLoading(completion: { [weak self] in
            self?.coordinator.goToDeviceTrustDeviceData()
        })
    }
    
    func doAuthenticate(token: String) {
        self.trackEvent(.clickInitSession)
        guard let password = loginConfiguration.password else {
            os_log("❌ [LOGIN][Authenticate] Mandatory field password is empty", log: .default, type: .error)
            let error = UseCaseError.error(PLUseCaseErrorOutput<LoginErrorType>(error: .emptyPass))
            self.trackEvent(.info, parameters: [PLLoginTrackConstants().errorCode: "1020", PLLoginTrackConstants().errorDescription: localized("login_popup_passwordRequired")])
            self.handleError(error)
            return
        }
        self.view?.showLoading()
        let authProcessInput = PLAuthProcessInput(scaCode: token,
                                                  password: password,
                                                  userId: loginConfiguration.userIdentifier,
                                                  challenge: loginConfiguration.challenge)
        
        authProcessUseCase.execute(input: authProcessInput) { [weak self]  nextSceneResult in
            guard let self = self else { return }
            self.trackEvent(.loginSuccess, parameters: [PLLoginTrackConstants().loginType : "hwToken"])
            switch nextSceneResult.nextScene {
            case .trustedDeviceScene:
                self.goToDeviceTrustDeviceData()
            case .globalPositionScene:
                self.openSessionAndNavigateToGlobalPosition()
                self.notificationGetTokenAndRegisterUseCase.executeUseCase {}
            }
        } onFailure: { [weak self]  error in
            let httpErrorCode = self?.getHttpErrorCode(error) ?? ""
            self?.trackEvent(.apiError, parameters: [PLLoginTrackConstants().errorCode : httpErrorCode, PLLoginTrackConstants().errorDescription : error.getErrorDesc() ?? ""])
            self?.handleError(error)
        }
    }
    
    func didSelectMenu() {
        self.coordinatorDelegate.didSelectMenu()
    }
}

extension PLHardwareTokenPresenter: PLLoginPresenterErrorHandlerProtocol {
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
    
    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }

    func openSessionAndNavigateToGlobalPosition() {
        Scenario(useCase: self.sessionUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: { [weak self] _ -> Scenario<Void, GetGlobalPositionOptionUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                return Scenario(useCase: self.globalPositionOptionUseCase)
            })
            .onSuccess( { [weak self] output in
                self?.goToGlobalPosition(output.globalPositionOption)

            })
            .onError { [weak self] _ in
                self?.goToGlobalPosition(.classic)
            }
    }

    func goToGlobalPosition(_ option: GlobalPositionOptionEntity) {
        self.coordinator.goToGlobalPositionScene(option)
    }
    
    func goBack() {
        view?.dismissLoading(completion: { [weak self] in
            self?.coordinator.goToUnrememberedLogindScene()
        })
    }
}

extension PLHardwareTokenPresenter: AutomaticScreenActionTrackable {
    var trackerManager: TrackerManager {
        return self.dependenciesResolver.resolve(for: TrackerManager.self)
    }

    var trackerPage: PLUnrememberedLoginHardwareTokenPage {
        return PLUnrememberedLoginHardwareTokenPage()
    }
}
