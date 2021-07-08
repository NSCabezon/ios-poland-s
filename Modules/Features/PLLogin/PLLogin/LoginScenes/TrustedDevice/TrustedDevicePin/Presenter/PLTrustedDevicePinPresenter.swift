//
//  PLTrustedDevicePinPresenter.swift
//  PLLogin

import Models
import Commons
import os

protocol PLTrustedDevicePinPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDevicePinViewProtocol? { get set }
    func viewDidLoad()
    func registerSoftwareToken(with createBiometricToken: Bool)
}

final class PLTrustedDevicePinPresenter {
    weak var view: PLTrustedDevicePinViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLTrustedDevicePinPresenter {
    var coordinator: PLTrustedDevicePinCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLTrustedDevicePinCoordinatorProtocol.self)
    }
    var deviceConfiguration: TrustedDeviceConfiguration {
        return self.dependenciesResolver.resolve(for: TrustedDeviceConfiguration.self)
    }
}

extension PLTrustedDevicePinPresenter: PLTrustedDevicePinPresenterProtocol {
    func viewDidLoad() {
        //TODO:
    }

    func registerSoftwareToken(with createBiometricToken: Bool) {
        guard let key = self.deviceConfiguration.softwareToken?.privateKey else {
            // TODO: Handle it
            return
        }

        let softwareTokenEncryptionUseCase = PLSoftwareTokenParametersEncryptionUseCase(dependenciesResolver: self.dependenciesResolver)
        let softwareTokenEncryptionUseCaseInput = PLSoftwareTokenParametersEncryptionUseCaseInput(parameters: self.deviceConfiguration.deviceData.parameters,
                                                                                                  key: key)
        Scenario(useCase: softwareTokenEncryptionUseCase, input: softwareTokenEncryptionUseCaseInput)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: {  [weak self] (output) -> Scenario<PLSoftwareTokenRegisterUseCaseInput, PLSoftwareTokenRegisterUseCaseOutput, PLSoftwareTokenUseCaseErrorOutput>? in
                guard let self = self else { return nil }

                let softwareTokenRegistrationUseCase = PLSoftwareTokenRegisterUseCase(dependenciesResolver: self.dependenciesResolver)
                let softwareTokenRegistrationUseCaseInput = PLSoftwareTokenRegisterUseCaseInput(createBiometricsToken: createBiometricToken,
                                                                                                appId: self.deviceConfiguration.deviceData.appId,
                                                                                                parameters: output.encryptedParameters,
                                                                                                deviceTime: self.deviceConfiguration.deviceData.deviceTime)
                return Scenario(useCase: softwareTokenRegistrationUseCase, input: softwareTokenRegistrationUseCaseInput)

            })
            .onSuccess({ [weak self] output in
                // TODO: Save output id, name, etc
                guard let self = self else { return }
                self.goToVoiceBotScreen()
            })
            .onError { error in
                // TODO: Present errorsecondFactorData
                os_log("❌ [TRUSTED-DEVICE][Register Software Token] Register did fail: %@", log: .default, type: .error, error.getErrorDesc() ?? "unknown error")
            }
    }
}

private extension PLTrustedDevicePinPresenter {

    func goToVoiceBotScreen() {
        self.coordinator.goToVoiceBotScene()
    }
}
