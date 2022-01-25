//
//  PLSmsAuthPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import CoreFoundationLib
import Commons
import PLCommons
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter
import Security
import os
import CoreDomain

protocol PLSmsAuthPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLSmsAuthViewProtocol? { get set }
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

    private var notificationTokenRegisterProcessGroup: PLNotificationTokenRegisterProcessGroup {
        return self.dependenciesResolver.resolve(for: PLNotificationTokenRegisterProcessGroup.self)
    }

    private var authProcessGroup: PLAuthProcessGroup {
        self.dependenciesResolver.resolve(for: PLAuthProcessGroup.self)
    }

    private var openSessionProcessGroup: PLOpenSessionProcessGroup {
        self.dependenciesResolver.resolve(for: PLOpenSessionProcessGroup.self)
    }
}

extension PLSmsAuthPresenter: PLSmsAuthPresenterProtocol {
    func didSelectLoginRestartAfterTimeOut() {
        self.coordinator.goToUnrememberedLogindScene()
    }

    func viewDidLoad() {
        self.trackScreen()
        self.doAuthenticateInit()
    }

    func viewWillAppear() {
    }

    func authenticate(smsCode: String) {
        self.doAuthenticate(smscode: smsCode)
    }
    
    func goToDeviceTrustDeviceData() {
        self.view?.dismissLoading(completion: { [weak self] in
            self?.coordinator.goToDeviceTrustDeviceData()
        })
    }
    
    func didSelectMenu() {
        self.coordinatorDelegate.didSelectMenu()
    }
}

//MARK: - Private Methods
private extension  PLSmsAuthPresenter {
    var coordinator: PLScaAuthCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLScaAuthCoordinatorProtocol.self)
    }
    
    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }

    func doAuthenticateInit() {        
        let caseInput: PLAuthenticateInitUseCaseInput = PLAuthenticateInitUseCaseInput(userId: loginConfiguration.userIdentifier, challenge: loginConfiguration.challenge)
        Scenario(useCase: self.authenticateInitUseCase, input: caseInput)
            .execute(on: self.dependenciesResolver.resolve())
            .onError { [weak self] error in
                let httpErrorCode = self?.getHttpErrorCode(error) ?? ""
                self?.trackEvent(.apiError, parameters: [PLLoginTrackConstants.errorCode : httpErrorCode, PLLoginTrackConstants.errorDescription : error.getErrorDesc() ?? ""])
                self?.handleError(error)
            }
    }

    func doAuthenticate(smscode: String) {
        self.trackEvent(.clickInitSession)
        guard let password = loginConfiguration.password else {
            os_log("❌ [LOGIN][Authenticate] Mandatory field password is empty", log: .default, type: .error)
            let error = UseCaseError.error(PLUseCaseErrorOutput<LoginErrorType>(error: .emptyPass))
            self.trackEvent(.info, parameters: [PLLoginTrackConstants.errorCode: "1010", PLLoginTrackConstants.errorDescription: localized("login_popup_passwordRequired")])
            self.handleError(error)
            return
        }
        
        self.view?.showLoading(title: localized("generic_popup_loading"),
                               subTitle: localized("loading_label_moment"),
                               completion: nil)

        let authProcessInput = PLAuthProcessGroupInput(scaCode: smscode,
                                                       password: password,
                                                       userId: loginConfiguration.userIdentifier,
                                                       challenge: loginConfiguration.challenge)

        authProcessGroup.execute(input: authProcessInput) { result in
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
                self.handleError(error.useCaseError, showCloseButton: true)
            }
        }
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
    
    func goBack() {
        view?.dismissLoading(completion: { [weak self] in
            self?.coordinator.goToUnrememberedLogindScene()
        })
    }
}

extension PLSmsAuthPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        self.goBack()
    }
}

extension PLSmsAuthPresenter: AutomaticScreenActionTrackable {
    var trackerManager: TrackerManager {
        return self.dependenciesResolver.resolve(for: TrackerManager.self)
    }

    var trackerPage: PLUnrememberedLoginSMSAuthPage {
        return PLUnrememberedLoginSMSAuthPage()
    }
}
