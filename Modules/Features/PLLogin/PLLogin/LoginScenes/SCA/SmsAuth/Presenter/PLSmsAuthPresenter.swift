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
//import PLNotifications

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
        
        let authProcessInput = PLAuthProcessInput(scaCode: smscode,
                                                  password: password,
                                                  userId: loginConfiguration.userIdentifier,
                                                  challenge: loginConfiguration.challenge)
        authProcessUseCase.execute(input: authProcessInput) { [weak self]  nextSceneResult in
            guard let self = self else { return }
            self.trackEvent(.loginSuccess, parameters: [PLLoginTrackConstants.loginType : "OTP"])
            switch nextSceneResult.nextScene {
            case .trustedDeviceScene:
                self.goToDeviceTrustDeviceData()
            case .globalPositionScene:
                self.openSessionAndNavigateToGlobalPosition()
                self.notificationGetTokenAndRegisterUseCase.executeUseCase {}
            }
        } onFailure: { [weak self]  error in
            let httpErrorCode = self?.getHttpErrorCode(error) ?? ""
            self?.trackEvent(.apiError, parameters: [PLLoginTrackConstants.errorCode : httpErrorCode, PLLoginTrackConstants.errorDescription : error.getErrorDesc() ?? ""])
            self?.handleError(error)
        }
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
    
    func goBack() {
        view?.dismissLoading(completion: { [weak self] in
            self?.coordinator.goToUnrememberedLogindScene()
        })
    }

    func goToGlobalPosition(_ option: GlobalPositionOptionEntity) {
        self.coordinator.goToGlobalPositionScene(option)
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
