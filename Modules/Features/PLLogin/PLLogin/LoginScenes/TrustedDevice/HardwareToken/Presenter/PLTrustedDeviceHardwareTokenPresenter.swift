//
//  PLTrustedDeviceHardwareTokenPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 23/8/21.
//

import Models
import Commons
import PLCommons
import SANPLLibrary
import os

protocol PLTrustedDeviceHardwareTokenPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDeviceHardwareTokenViewProtocol? { get set }
    func viewDidLoad()
    func goToDeviceTrustDeviceData()
    func registerConfirm(code: String)
}

final class PLTrustedDeviceHardwareTokenPresenter {
    weak var view: PLTrustedDeviceHardwareTokenViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLTrustedDeviceHardwareTokenPresenter {
    var coordinator: PLTrustedDeviceHardwareTokenCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLTrustedDeviceHardwareTokenCoordinatorProtocol.self)
    }
    private var deviceConfiguration: TrustedDeviceConfiguration {
        return self.dependenciesResolver.resolve(for: TrustedDeviceConfiguration.self)
    }
    
    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }
    
    private var registerConfirmUseCase: PLRegisterConfirmUseCase {
        self.dependenciesResolver.resolve(for: PLRegisterConfirmUseCase.self)
    }
    
    private var storeTrustedDeviceHeadersUseCase: PLTrustedDeviceStoreHeadersUseCase {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceStoreHeadersUseCase.self)
    }
    
    private var secondFactorChallengeUseCase: PLTrustedDeviceSecondFactorChallengeUseCase {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceSecondFactorChallengeUseCase.self)
    }
}

extension PLTrustedDeviceHardwareTokenPresenter: PLTrustedDeviceHardwareTokenPresenterProtocol {
    func viewDidLoad() {
        self.calculateChallenge()
    }

    func goToDeviceTrustDeviceData() {
        self.coordinator.goToDeviceTrustDeviceData()
    }
    
    func registerConfirm(code: String) {
        guard let tokens: [TrustedDeviceSoftwareToken] = self.deviceConfiguration.tokens,
              let pinToken = tokens.first(where: { $0.type == "PIN" }) else {
            self.handleError(UseCaseError.error(PLUseCaseErrorOutput(errorDescription: "Required parameter not found")))
            return
        }
        
        self.view?.showLoading(completion: { [weak self] in
            guard let self = self else { return }
            let input = PLRegisterConfirmUseCaseInput(pinSoftwareTokenId: pinToken.id,
                                                      timestamp: pinToken.timestamp,
                                                      secondFactorResponseDevice: AuthorizationType.tokenTimeCR.rawValue,
                                                      secondFactorResponseValue: code)
            
            Scenario(useCase: self.registerConfirmUseCase, input: input)
                .execute(on: self.dependenciesResolver.resolve())
                .onSuccess({ [weak self] output in
                    guard let self = self else { return }
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
                    self.storeTrustedDeviceHeadersPersistenlty()
                    self.goToTrustedDeviceSuccess()
                })
                .onError { [weak self] error in
                    self?.handleError(error)
                }
        })
    }
}

private extension PLTrustedDeviceHardwareTokenPresenter {
    
    func calculateChallenge() {
        let userId = Int(loginConfiguration.userIdentifier) ?? 0
        let secondFactorChallengeInput = PLTrustedDeviceSecondFactorChallengeInput(userId: userId,
                                                                                   configuration: deviceConfiguration)
        Scenario(useCase: self.secondFactorChallengeUseCase, input: secondFactorChallengeInput)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess({ [weak self] output in
                guard let challenge = output.challenge else {
                    self?.handleError(UseCaseError.error(PLUseCaseErrorOutput<LoginErrorType>(error: .emptyField)))
                    return
                }
                self?.view?.showChallenge(challenge: challenge)
            })
            .onError({ [weak self] error in
                self?.handleError(error)
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
    
    func goToTrustedDeviceSuccess() {
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            self.coordinator.goToTrustedDeviceSuccess()
        })
    }
}

extension PLTrustedDeviceHardwareTokenPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        return view
    }

    func genericErrorPresentedWith(error: PLGenericError) {
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            self.goToDeviceTrustDeviceData()
        })
    }
    
    func handle(error: PLGenericError) {
        switch error {
        case .unauthorized:
            view?.showAuthErrorDialog()
        case .other(let description):
            //Expired token (error 422), no sure if this will happen for hardware tokens
            guard description == "UNPROCESSABLE_ENTITY" else {
                associatedErrorView?.presentError(error, completion: { [weak self] in
                    self?.coordinator.goToDeviceTrustDeviceData()
                })
                return
            }
            self.associatedErrorView?.presentError(("pl_onboarding_alert_timeExpTitle",
                                                    "pl_onboarding_alert_timeExpText"), completion: { [weak self] in
                self?.goToDeviceTrustDeviceData()
            })
        default:
            associatedErrorView?.presentError(error, completion: { [weak self] in
                self?.goToDeviceTrustDeviceData()
            })
        }
    }
}
