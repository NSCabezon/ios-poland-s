//
//  PLTrustedDeviceSmsAuthPresenter.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 11/8/21.
//
import Models
import Commons
import PLCommons
import SANPLLibrary

protocol PLTrustedDeviceSmsAuthPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDeviceSmsAuthViewProtocol? { get set }
    func viewDidLoad()
    func goBack()
    func registerConfirm(smsCode: String)
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

    private var storeTrustedDeviceHeadersUseCase: PLTrustedDeviceStoreHeadersUseCase {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceStoreHeadersUseCase.self)
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func viewDidLoad() {
        requestSMSConfirmationCode()
    }
    
    func goBack() {
        coordinator.goBack()
    }
    
    func registerConfirm(smsCode: String) {
        guard let tokens: [TrustedDeviceSoftwareToken] = self.deviceConfiguration.tokens,
              let pinToken = tokens.first(where: { $0.type == "PIN" })
        else {
            self.handleError(UseCaseError.error(PLUseCaseErrorOutput(errorDescription: "Required parameter not found")))
            return
        }
        
        self.view?.showLoading(completion: { [weak self] in
            guard let self = self else { return }
            let input = PLRegisterConfirmUseCaseInput(pinSoftwareTokenId: pinToken.id,
                                                      timestamp: pinToken.timestamp,
                                                      secondFactorResponseDevice: "SMS_CODE",
                                                      secondFactorResponseValue: smsCode)

            Scenario(useCase: self.registerConfirmUseCase, input: input)
                .execute(on: self.dependenciesResolver.resolve())
                .onSuccess({ [weak self] output in
                    guard let self = self else { return }
                    self.deviceConfiguration.registrationConfirm = TrustedDeviceConfiguration.RegistrationConfirm(id: output.id,
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
                    self.storeTrustedDeviceHeadersPersistenlty()
                    self.goToTrustedDeviceSuccess()
                })
                .onError { [weak self] error in
                    self?.handleError(error)
                }
        })
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

        guard let ivrCode = deviceConfiguration.ivrOutputCode,
              let trustedDeviceId = deviceConfiguration.trustedDevice?.trustedDeviceId,
              let deviceTime = deviceConfiguration.trustedDevice?.trustedDeviceTimestamp,
              let tokens = deviceConfiguration.tokens else { return }

        let userId = Int(loginConfiguration.userIdentifier) ?? 0
        let challengeTokens = tokens.compactMap {
            return PLTrustedDeviceSecondFactorChallengeInput.PLTrustedDeviceSecondFactorChallengeToken(id: $0.id,
                                                                                                       timestamp: $0.timestamp)
        }
        let secondFactorChallengeInput = PLTrustedDeviceSecondFactorChallengeInput(ivrCode: ivrCode,
                                                                                   trustedDeviceId: trustedDeviceId,
                                                                                   deviceTimestamp: deviceTime,
                                                                                   userId: userId,
                                                                                   tokens: challengeTokens)
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
        self.goBack()
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
