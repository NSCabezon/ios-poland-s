//
//  PLHardwareTokenPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 20/7/21.
//

import CoreFoundationLib
import Commons
import PLCommons
import LoginCommon
import os
import CoreDomain

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

    private var authProcessGroup: PLAuthProcessGroup {
        self.dependenciesResolver.resolve(for: PLAuthProcessGroup.self)
    }

    private var notificationTokenRegisterProcessGroup: PLNotificationTokenRegisterProcessGroup {
        return self.dependenciesResolver.resolve(for: PLNotificationTokenRegisterProcessGroup.self)
    }

    private var openSessionProcessGroup: PLOpenSessionProcessGroup {
        return self.dependenciesResolver.resolve(for: PLOpenSessionProcessGroup.self)
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
            self.trackEvent(.info, parameters: [PLLoginTrackConstants.errorCode: "1020", PLLoginTrackConstants.errorDescription: localized("login_popup_passwordRequired")])
            self.handleError(error)
            return
        }
        self.view?.showLoading()

        let authProcessGroupInput = PLAuthProcessGroupInput(scaCode: token,
                                                            password: password,
                                                            userId: loginConfiguration.userIdentifier,
                                                            challenge: loginConfiguration.challenge)
        authProcessGroup.execute(input: authProcessGroupInput) { result in
            switch result {
            case .success(let output):
                self.trackEvent(.loginSuccess, parameters: [PLLoginTrackConstants.loginType : "OTP"])
                switch output.nextScene {
                case .trustedDeviceScene:
                    self.goToDeviceTrustDeviceData()
                case .globalPositionScene:
                    self.openSessionAndNavigateToGlobalPosition()
                    self.notificationTokenRegisterProcessGroup.execute { _ in }
                }
            case .failure(let error):
                let httpErrorCode = self.getHttpErrorCode(error.useCaseError) ?? ""
                self.trackEvent(.apiError, parameters: [PLLoginTrackConstants.errorCode : httpErrorCode, PLLoginTrackConstants.errorDescription : error.useCaseError.getErrorDesc() ?? ""])
                self.handleError(error.useCaseError, showTitle: false)
            }

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
        openSessionProcessGroup.execute { [weak self] result in
            switch result {
            case .success(let output):
                self?.coordinator.goToGlobalPositionScene(output.globalPositionOption)
            case .failure(_):
                self?.coordinator.goToGlobalPositionScene(.classic)
            }
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
