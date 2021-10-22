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
    func registerSoftwareToken(with createBiometricToken: Bool, and PIN: String)
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
    private var userKeyReEncryptionUseCase: PLTrustedDeviceUserKeyReEncryptionUseCase {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceUserKeyReEncryptionUseCase.self)
    }
    private var storeEncryptedUserKeyUseCase: PLTrustedDeviceStoreEncryptedUserKeyUseCase {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceStoreEncryptedUserKeyUseCase.self)
    }
    private var getSecIdentityUseCase: PLGetSecIdentityUseCase {
        self.dependenciesResolver.resolve(for: PLGetSecIdentityUseCase.self)
    }
}

extension PLTrustedDevicePinPresenter: PLTrustedDevicePinPresenterProtocol {
    func viewDidLoad() {
    }

    func registerSoftwareToken(with createBiometricToken: Bool, and PIN: String) {
        guard let key = self.deviceConfiguration.softwareToken?.identity?.privateKey,
            let deviceData = self.deviceConfiguration.deviceData else {
            self.handleError(UseCaseError.error(PLUseCaseErrorOutput<LoginErrorType>(error: .emptyField)))
            return
        }
        
        self.view?.showLoading(title: localized("generic_popup_loading"),
                               subTitle: localized("loading_label_moment"),
                               completion: nil)

        var deviceHeaders: TrustedDeviceConfiguration.DeviceHeaders?
        var tokens: [TrustedDeviceSoftwareToken]?

        let softwareTokenEncryptionUseCase = PLSoftwareTokenParametersEncryptionUseCase(dependenciesResolver: self.dependenciesResolver)
        let softwareTokenEncryptionUseCaseInput = PLSoftwareTokenParametersEncryptionUseCaseInput(parameters: deviceData.parameters,
                                                                                                  key: key)
        Scenario(useCase: softwareTokenEncryptionUseCase, input: softwareTokenEncryptionUseCaseInput)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: {  [weak self] (output) -> Scenario<PLSoftwareTokenRegisterUseCaseInput, PLSoftwareTokenRegisterUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }

                deviceHeaders = TrustedDeviceConfiguration.DeviceHeaders(encryptedParameters: output.encryptedParameters,
                                                                         time: deviceData.deviceTime,
                                                                         appId: deviceData.appId)

                let softwareTokenRegistrationUseCase = PLSoftwareTokenRegisterUseCase(dependenciesResolver: self.dependenciesResolver)
                let softwareTokenRegistrationUseCaseInput = PLSoftwareTokenRegisterUseCaseInput(createBiometricsToken: createBiometricToken,
                                                                                                appId: deviceData.appId,
                                                                                                parameters: output.encryptedParameters,
                                                                                                deviceTime: deviceData.deviceTime)
                return Scenario(useCase: softwareTokenRegistrationUseCase, input: softwareTokenRegistrationUseCaseInput)
            })
            .then(scenario: {  [weak self] (output) -> Scenario<PLTrustedDeviceUserKeyReEncryptionUseCaseInput, PLTrustedDeviceUserKeyReEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                tokens = output.tokens
                guard let tokens = tokens else { return nil }
                let useCaseInput = PLTrustedDeviceUserKeyReEncryptionUseCaseInput(appId: deviceData.appId,
                                                                                  pin: PIN,
                                                                                  privateKey: key,
                                                                                  tokens: tokens)
                return Scenario(useCase: self.userKeyReEncryptionUseCase, input: useCaseInput)
            })
            .then(scenario: {  [weak self] (output) -> Scenario<PLTrustedDeviceStoreEncryptedUserKeyUseCaseInput, Void, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                let useCaseInput = PLTrustedDeviceStoreEncryptedUserKeyUseCaseInput(encryptedUserKeyPIN: output.reEncryptedUserKeyPIN,
                                                                                    encryptedUserKeyBiometrics: output.reEncryptedUserKeyBiometrics)
                return Scenario(useCase: self.storeEncryptedUserKeyUseCase, input: useCaseInput)
            })
            .onSuccess({ [weak self] output in
                guard let self = self else { return }
                self.deviceConfiguration.tokens = tokens
                self.deviceConfiguration.deviceHeaders = deviceHeaders
                self.goToVoiceBotScreen()
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
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            self.coordinator.goToDeviceTrustDeviceData()
        })
    }
}

private extension PLTrustedDevicePinPresenter {

    func goToVoiceBotScreen() {
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            self.coordinator.goToVoiceBotScene()
        })
    }
}
