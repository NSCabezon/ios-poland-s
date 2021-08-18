//
//  VoiceBotPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 29/7/21.
//

import Models
import Commons
import PLCommons
import os

protocol PLVoiceBotPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLVoiceBotViewProtocol? { get set }
    func viewDidLoad()
    func getDevices()
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
    func viewDidLoad() {
        guard let ivrInputCode = deviceConfiguration.trustedDevice?.ivrInputCode else { return }
        self.view?.setIvrInputCode(ivrInputCode)
    }
    
    func getDevices() {
        Scenario(useCase: devicesUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess({ [weak self] output in
                self?.goToSmsAuth()
            }).onError({[weak self] error in
                self?.handleError(error)
            })
    }
    
    func requestIVRCall() {
        guard let trustedDeviceId = self.deviceConfiguration.trustedDevice?.trustedDeviceId else { return }
        let input = PLIvrRegisterUseCaseInput(trustedDeviceId: String(trustedDeviceId))
        Scenario(useCase: ivrRegisterUseCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess({ [weak self] output in
                self?.view?.showIVCCallSendedDialog()
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
        self.goToHardwareTokenScreen()
    }
}

private extension PLVoiceBotPresenter {

    func goToHardwareTokenScreen() {
        self.coordinator.goToHardwareToken()
    }
    
    func goToSmsAuth() {
        self.coordinator.goToSmsAuth()
    }
}
