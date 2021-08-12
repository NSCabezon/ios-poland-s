//
//  PLTrustedDevicePinPresenter.swift
//  PLLogin

import Models
import Commons
import PLCommons
import os

protocol PLTrustedDevicePinPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDevicePinViewProtocol? { get set }
    func viewDidLoad()
    func registerSoftwareToken(with createBiometricToken: Bool)
    func goToDeviceTrustDeviceData()
    func shouldShowBiometry() -> Bool
}

final class PLTrustedDevicePinPresenter {
    weak var view: PLTrustedDevicePinViewProtocol?
    internal let dependenciesResolver: DependenciesResolver
    private let localAuth: LocalAuthenticationPermissionsManagerProtocol

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.localAuth = dependenciesResolver.resolve(for: LocalAuthenticationPermissionsManagerProtocol.self)
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
    }

    func registerSoftwareToken(with createBiometricToken: Bool) {
        guard let key = self.deviceConfiguration.softwareToken?.privateKey else {
            self.handleError(UseCaseError.error(PLUseCaseErrorOutput<LoginErrorType>(error: .emptyField)))
            return
        }

        let softwareTokenEncryptionUseCase = PLSoftwareTokenParametersEncryptionUseCase(dependenciesResolver: self.dependenciesResolver)
        let softwareTokenEncryptionUseCaseInput = PLSoftwareTokenParametersEncryptionUseCaseInput(parameters: self.deviceConfiguration.deviceData.parameters,
                                                                                                  key: key)
        Scenario(useCase: softwareTokenEncryptionUseCase, input: softwareTokenEncryptionUseCaseInput)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: {  [weak self] (output) -> Scenario<PLSoftwareTokenRegisterUseCaseInput, PLSoftwareTokenRegisterUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
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
                self?.goToVoiceBotScreen()
            })
            .onError { [weak self] error in
                os_log("❌ [TRUSTED-DEVICE][Register Software Token] Register did fail: %@", log: .default, type: .error, error.getErrorDesc() ?? "unknown error")
                self?.handleError(error)
            }
    }

    func goToDeviceTrustDeviceData() {
        self.coordinator.goToDeviceTrustDeviceData()
    }

    func shouldShowBiometry() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        let biometryAvailable = self.localAuth.biometryTypeAvailable
        return biometryAvailable == .faceId || biometryAvailable == .touchId
        #endif
    }
}

extension PLTrustedDevicePinPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        return view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        //
    }
}

private extension PLTrustedDevicePinPresenter {

    func goToVoiceBotScreen() {
        self.coordinator.goToVoiceBotScene()
    }
}
