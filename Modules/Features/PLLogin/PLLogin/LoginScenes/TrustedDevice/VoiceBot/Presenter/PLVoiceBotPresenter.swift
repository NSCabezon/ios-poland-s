//
//  VoiceBotPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 29/7/21.
//

import Models
import Commons
import PLCommons
import SANPLLibrary
import os

protocol PLVoiceBotPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLVoiceBotViewProtocol? { get set }
    func viewDidLoad()
    func getDevices()
    func setIvrOutputcode(code: Int)
    func requestIVRCall()
}

final class PLVoiceBotPresenter {
    weak var view: PLVoiceBotViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLVoiceBotPresenter {
    var coordinator: PLVoiceBotCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLVoiceBotCoordinatorProtocol.self)
    }
    var deviceConfiguration: TrustedDeviceConfiguration {
        return self.dependenciesResolver.resolve(for: TrustedDeviceConfiguration.self)
    }
    
    var ivrRegisterUseCase: PLIvrRegisterUseCase {
        self.dependenciesResolver.resolve(for: PLIvrRegisterUseCase.self)
    }
    
    var devicesUseCase: PLDevicesUseCase {
        self.dependenciesResolver.resolve(for: PLDevicesUseCase.self)
    }
}

extension PLVoiceBotPresenter: PLVoiceBotPresenterProtocol {
    
    func setIvrOutputcode(code: Int) {
        self.deviceConfiguration.ivrOutputCode = code
    }
    
    func viewDidLoad() {
        guard let ivrInputCode = deviceConfiguration.trustedDevice?.ivrInputCode else { return }
        self.view?.setIvrInputCode(ivrInputCode)
    }
    
    func getDevices() {
        Scenario(useCase: devicesUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess({ [weak self] output in
                guard let self = self else { return }
                let challenge = self.getChallenge(from: output.defaultAuthorizationType,
                                                  allowedAuthTypes: output.allowedAuthorizationTypes)
                
                if challenge == .sms {
                    self.goToSmsAuthScreen()
                } else if challenge == .tokenTime {
                    self.goToHardwareTokenAuthScreen()
                } else {
                    self.handle(error: .applicationNotWorking)
                }
            }).onError({[weak self] error in
                self?.handleError(error)
            })
    }
    
    func requestIVRCall() {
        guard let trustedDeviceId = self.deviceConfiguration.trustedDevice?.trustedDeviceId else { return }
        let input = PLIvrRegisterUseCaseInput(trustedDeviceId: String(trustedDeviceId))
        Scenario(useCase: ivrRegisterUseCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess({ [weak self] code in
                self?.view?.showIVCCallSendedDialog(code: code)
            }).onError({ [weak self] error in
                self?.handleError(error)
            })
    }
}

extension PLVoiceBotPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        //go back
    }
}

private extension PLVoiceBotPresenter {

    
    func goToSmsAuthScreen() {
        self.coordinator.goToSmsAuth()
    }
    
    func goToHardwareTokenAuthScreen() {
        self.coordinator.goToHardwareToken()
    }
    
    func getChallenge(from defaultAuthType: AuthorizationType,
                      allowedAuthTypes: [AuthorizationType]?) -> AuthorizationType? {
        switch defaultAuthType {
        case .softwareToken:
            if (allowedAuthTypes?.first(where: { $0 == .sms })) != nil {
                return .sms
            } else if (allowedAuthTypes?.first(where: { $0 == .tokenTime || $0 == .tokenTimeCR })) != nil {
                return .tokenTime
            } else {
                return .softwareToken
            }
        default:
           return defaultAuthType
        }
    }
}
