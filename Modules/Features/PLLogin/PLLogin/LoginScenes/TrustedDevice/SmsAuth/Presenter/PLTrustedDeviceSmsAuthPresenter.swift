//
//  PLTrustedDeviceSmsAuthPresenter.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 11/8/21.
//
import CoreFoundationLib
import PLCommons
import SANPLLibrary

protocol PLTrustedDeviceSmsAuthPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDeviceSmsAuthViewProtocol? { get set }
    func viewDidLoad()
    func goBack()
    func registerConfirm(smsCode: String)
    func closeButtonDidPressed()
}

final class PLTrustedDeviceSmsAuthPresenter: PLTrustedDeviceSmsAuthPresenterProtocol {
    
    internal let dependenciesResolver: DependenciesResolver
    weak var view: PLTrustedDeviceSmsAuthViewProtocol?
    
    var deviceConfiguration: TrustedDeviceConfiguration {
        return self.dependenciesResolver.resolve(for: TrustedDeviceConfiguration.self)
    }
    
    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }

    private var secondFactorChallengeUseCase: PLTrustedDeviceSecondFactorChallengeUseCase {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceSecondFactorChallengeUseCase.self)
    }
    
    var confirmationCodeRegisterUseCase: PLConfirmationCodeRegisterUseCase {
        self.dependenciesResolver.resolve(for: PLConfirmationCodeRegisterUseCase.self)
    }

    private var registerConfirmUseCase: PLRegisterConfirmUseCase {
        self.dependenciesResolver.resolve(for: PLRegisterConfirmUseCase.self)
    }
    
    private var trustedDeviceInfoUseCase: PLTrustedDeviceInfoUseCase {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceInfoUseCase.self)
    }

    private var storeTrustedDeviceHeadersUseCase: PLTrustedDeviceStoreHeadersUseCase {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceStoreHeadersUseCase.self)
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func viewDidLoad() {
        self.trackerManager.trackScreen(screenId: PLLoginTrustedDeviceSMSAuthPage().page, extraParameters: [PLLoginTrackConstants.referer : PLLoginTrustedDeviceVoiceBotPage().page])
        requestSMSConfirmationCode()
    }
    
    func goBack() {
        coordinator.goBack()
    }
    
    func registerConfirm(smsCode: String) {
        self.trackEvent(.clickContinue)
        guard let tokens: [TrustedDeviceSoftwareToken] = self.deviceConfiguration.tokens,
              let pinToken = tokens.first(where: { $0.typeMapped == .PIN })
        else {
            self.handleError(UseCaseError.error(PLUseCaseErrorOutput(errorDescription: "Required parameter not found")))
            return
        }
                
        self.view?.showLoading(completion: { [weak self] in
            guard let self = self else { return }
            let input = PLRegisterConfirmUseCaseInput(pinSoftwareTokenId: pinToken.id,
                                                      timestamp: pinToken.timestamp,
                                                      secondFactorResponseDevice: AuthorizationType.sms.rawValue,
                                                      secondFactorResponseValue: smsCode)

            Scenario(useCase: self.registerConfirmUseCase, input: input)
                .execute(on: self.dependenciesResolver.resolve())
                .then(scenario: { [weak self] output -> Scenario<PLTrustedDeviceStoreHeadersInput, Void, PLUseCaseErrorOutput<LoginErrorType>>? in
                    guard let self = self else { return nil }
                    let rConfirm = TrustedDeviceConfiguration.RegistrationConfirm(id: output.id,
                                                                            state: output.state,
                                                                            badTriesCount: output.badTriesCount,
                                                                            triesAllowed: output.triesAllowed,
                                                                            timestamp: output.timestamp,
                                                                            name: output.name,
                                                                            key: output.key,
                                                                            type: output.type,
                                                                            trustedDeviceId: output.trustedDeviceId,
                                                                            dateOfLastStatusChange: output.dateOfLastStatusChange,
                                                                            properUseCount: output.properUseCount,
                                                                            badUseCount: output.badUseCount,
                                                                            dateOfLastProperUse: output.dateOfLastProperUse,
                                                                            dateOfLastBadUse: output.dateOfLastBadUse)
                    self.deviceConfiguration.registrationConfirm = rConfirm
                    guard let deviceHeaders = self.deviceConfiguration.deviceHeaders else { return nil }
                    let input = PLTrustedDeviceStoreHeadersInput(parameters: deviceHeaders.encryptedParameters,
                                                                 time: deviceHeaders.time,
                                                                 appId: deviceHeaders.appId)
                    return Scenario(useCase: self.storeTrustedDeviceHeadersUseCase, input: input)
                })
                .then(scenario: { [weak self] output -> Scenario<PLTrustedDeviceInfoInput, PLTrustedDeviceInfoOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                    guard let self = self else { return nil }
                    let params = PLTrustedDeviceInfoInput(trustedDeviceAppId: self.deviceConfiguration.deviceData?.appId ?? "")
                    return Scenario(useCase: self.trustedDeviceInfoUseCase, input: params)
                })
                .onSuccess({ [weak self] output in
                    guard let self = self else { return }
                    self.goToTrustedDeviceSuccess()
                })
                .onError { [weak self] error in
                    let httpErrorCode = self?.getHttpErrorCode(error) ?? ""
                    self?.trackEvent(.apiError, parameters: [PLLoginTrackConstants.errorCode : httpErrorCode, PLLoginTrackConstants.errorDescription : error.getErrorDesc() ?? ""])
                    self?.handleError(error)
                }
        })
    }

    func closeButtonDidPressed() {
        self.trackEvent(.clickCancel)
    }

    func storeTrustedDeviceHeadersPersistenlty() {

        guard let deviceHeaders = self.deviceConfiguration.deviceHeaders else { return }
        let input = PLTrustedDeviceStoreHeadersInput(parameters: deviceHeaders.encryptedParameters,
                                                     time: deviceHeaders.time,
                                                     appId: deviceHeaders.appId)

        Scenario(useCase: self.storeTrustedDeviceHeadersUseCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
    }
    
    func requestSMSConfirmationCode() {
        guard let deviceId = deviceConfiguration.trustedDevice?.trustedDeviceId else {
            self.handleError(UseCaseError.error(PLUseCaseErrorOutput<LoginErrorType>(error: .emptyField)))
            return
        }

        let userId = Int(loginConfiguration.userIdentifier) ?? 0
        let secondFactorChallengeInput = PLTrustedDeviceSecondFactorChallengeInput(userId: userId,
                                                                                   configuration: deviceConfiguration)
        Scenario(useCase: self.secondFactorChallengeUseCase, input: secondFactorChallengeInput)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: {  [weak self] (output) -> Scenario<PLPLConfirmationCodeRegisterInput, Void, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self, let challenge = output.challenge else { return nil }
                let input = PLPLConfirmationCodeRegisterInput(trustedDeviceId: String(deviceId),
                                                              secondFactorSmsChallenge: challenge,
                                                              language: self.getLanguage())
                return Scenario(useCase: self.confirmationCodeRegisterUseCase, input: input)
            })
            .onSuccess({ _ in
                //SMS sent
            })
            .onError { [weak self] error in
                let httpErrorCode = self?.getHttpErrorCode(error) ?? ""
                self?.trackEvent(.apiError, parameters: [PLLoginTrackConstants.errorCode : httpErrorCode, PLLoginTrackConstants.errorDescription : error.getErrorDesc() ?? ""])
                self?.handleError(error)
            }
    }
}

private extension PLTrustedDeviceSmsAuthPresenter {
    
    var coordinator: PLTrustedDeviceSmsAuthCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLTrustedDeviceSmsAuthCoordinatorProtocol.self)
    }

    func getLanguage() -> String {
        return dependenciesResolver.resolve(forOptionalType: StringLoader.self)?.getCurrentLanguage().languageType.rawValue ?? "en"
    }
    
    func goToTrustedDeviceSuccess() {
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            self.coordinator.goToTrustedDeviceSuccess()
        })
    }
}

extension PLTrustedDeviceSmsAuthPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            self.goBack()
        })
    }
    
    func handle(error: PLGenericError) {
        switch error {
        case .unauthorized:
            view?.showAuthErrorDialog()
        case .other(let description):
            //Expired otp (error 422)
            guard description == "UNPROCESSABLE_ENTITY" else {
                associatedErrorView?.presentError(error, completion: { [weak self] in
                    self?.goBack()
                })
                return
            }
            self.associatedErrorView?.presentError(("pl_onboarding_alert_timeExpTitle",
                                                    "pl_onboarding_alert_timeExpText"), completion: { [weak self] in
                self?.goBack()
            })
        default:
            associatedErrorView?.presentError(error, completion: { [weak self] in
                self?.goBack()
            })
        }
    }
}

extension PLTrustedDeviceSmsAuthPresenter: AutomaticScreenActionTrackable {
    var trackerManager: TrackerManager {
        return self.dependenciesResolver.resolve(for: TrackerManager.self)
    }

    var trackerPage: PLLoginTrustedDeviceSMSAuthPage {
        return PLLoginTrustedDeviceSMSAuthPage()
    }
}
