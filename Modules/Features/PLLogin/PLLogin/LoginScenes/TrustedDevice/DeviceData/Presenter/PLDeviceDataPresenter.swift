//
//  PLDeviceDataPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 16/6/21.
//

import DomainCommon
import Commons
import PLCommons
import Models
import os
import UI

protocol PLDeviceDataPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLDeviceDataViewProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func registerDevice()
}

enum PLDeviceDataEncryptionError: Error {
    case transportKeyEncryptionError
    case parametersEncryptionError
    case certificateCreationError
}

final class PLDeviceDataPresenter {
    weak var view: PLDeviceDataViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    // TODO: This dependency should not exist at this point. This is part of the Login process.
    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }

    private var transportKeyEncryptionUseCase: PLDeviceDataTransportKeyEncryptionUseCase {
        self.dependenciesResolver.resolve(for: PLDeviceDataTransportKeyEncryptionUseCase.self)
    }

    private var parametersEncryptionUseCase: PLDeviceDataParametersEncryptionUseCase {
        self.dependenciesResolver.resolve(for: PLDeviceDataParametersEncryptionUseCase.self)
    }

    private var certificatCreationUseCase: PLDeviceDataCertificateCreationUseCase {
        self.dependenciesResolver.resolve(for: PLDeviceDataCertificateCreationUseCase.self)
    }

    private var registerDeviceUseCase: PLDeviceDataRegisterDeviceUseCase {
        self.dependenciesResolver.resolve(for: PLDeviceDataRegisterDeviceUseCase.self)
    }

    private var generateDeviceDataUseCase: PLDeviceDataGenerateDataUseCase {
        self.dependenciesResolver.resolve(for: PLDeviceDataGenerateDataUseCase.self)
    }

    var coordinator: PLDeviceDataCoordinatorProtocol {
        self.dependenciesResolver.resolve(for: PLDeviceDataCoordinatorProtocol.self)
    }

    private lazy var deviceConfiguration: TrustedDeviceConfiguration = {
        return TrustedDeviceConfiguration()
    }()

    private lazy var transportKey: String = {
        return PLLoginTrustedDeviceHelpers.secureRandom(bytesNumber: 16)?.toHexString() ?? ""
    }()
}

extension PLDeviceDataPresenter: PLLoginPresenterErrorHandlerProtocol {
    
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        return view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        //
    }
}

extension PLDeviceDataPresenter: PLDeviceDataPresenterProtocol {

    func viewDidLoad() {
    }

    func viewWillAppear() {
        self.generateDeviceData()
    }

    func registerDevice() {
        
        self.view?.showLoading(title: localized("generic_popup_loading"),
                               subTitle: localized("loading_label_moment"),
                               completion: nil)
        
        guard let password = loginConfiguration.password,
              let deviceData = self.deviceConfiguration.deviceData else {
            // TODO: create a tustedDevieConfiguration for not using the one from loginConfiguration
            self.handleError(UseCaseError.error(PLUseCaseErrorOutput<LoginErrorType>(error: .emptyPass)))
            return
        }

        let transportKeyEncryptionUseCaseInput = PLDeviceDataTransportKeyEncryptionUseCaseInput(transportKey: self.transportKey,
                                                                                                passKey: password)
        let trasportKeyScenario = Scenario(useCase: self.transportKeyEncryptionUseCase, input: transportKeyEncryptionUseCaseInput)

        let parametersEncryptionUseCaseInput = PLDeviceDataParametersEncryptionUseCaseInput(parameters: deviceData.parameters,
                                                                                            transportKey: transportKey)
        let parametersScenario = Scenario(useCase: self.parametersEncryptionUseCase, input: parametersEncryptionUseCaseInput)

        let certificateCreationUseCaseInput = PLDeviceDataCertificateCreationUseCaseInput()
        let certificateScenario = Scenario(useCase: self.certificatCreationUseCase, input: certificateCreationUseCaseInput)

        let values: (transportKeyEncryption: String?, parametersEncryption: String?, certificate: String?, privateKey: SecKey?) = (nil, nil, nil, nil)
        MultiScenario(handledOn: self.dependenciesResolver.resolve(), initialValue: values)
            .addScenario(trasportKeyScenario) { (updatedValues, output, _) in
                updatedValues.transportKeyEncryption = output.encryptedTransportKey
            }.addScenario(parametersScenario) { (updatedValues, output, _) in
                updatedValues.parametersEncryption = output.encryptedParameters
            }.addScenario(certificateScenario) { (updatedValues, output, _) in
                updatedValues.certificate = output.certificate
                updatedValues.privateKey = output.privateKey
            }.then(scenario: { (transportKeyEncryption, parametersEncryption, certificate, key) -> Scenario<PLDeviceDataRegisterDeviceUseCaseInput, PLDeviceDataRegisterDeviceUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> in
                let registerDeviceUseCaseInput = PLDeviceDataRegisterDeviceUseCaseInput(transportKey: transportKeyEncryption ?? "",
                                                                                        deviceParameters: parametersEncryption ?? "",
                                                                                        deviceTime: deviceData.deviceTime,
                                                                                        certificate: certificate ?? "",
                                                                                        appId: deviceData.appId)

                // TODO: Save certificate and pair of keys
                let softwareToken = TrustedDeviceConfiguration.SoftwareToken(privateKey: key,
                                                                             certificatePEM: certificate)
                self.deviceConfiguration.softwareToken = softwareToken

                return Scenario(useCase: self.registerDeviceUseCase, input: registerDeviceUseCaseInput)
            })
            .onSuccess { [weak self] registerSoftwareTokenOutput in
                guard let self = self else { return }
                let trustedDeviceInfo = TrustedDeviceConfiguration.TrustedDevice(trustedDeviceId: registerSoftwareTokenOutput.trustedDeviceId,
                                                                                 userId: registerSoftwareTokenOutput.userId,
                                                                                 trustedDeviceState: registerSoftwareTokenOutput.trustedDeviceState,
                                                                                 trustedDeviceTimestamp: registerSoftwareTokenOutput.trustedDeviceTimestamp,
                                                                                 ivrInputCode: registerSoftwareTokenOutput.ivrInputCode)
                self.deviceConfiguration.trustedDevice = trustedDeviceInfo
                self.goToTrustedDevicePIN()
            }.onError { [weak self] error in
                self?.handleError(error)
            }
    }

    func goToTrustedDevicePIN() {
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            self.coordinator.goToTrustedDevicePIN(with: self.deviceConfiguration)
        })
    }
}

private extension PLDeviceDataPresenter {

    func generateDeviceData() {
        Scenario(useCase: self.generateDeviceDataUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { output in
                self.deviceConfiguration.deviceData = output.deviceData
            }.finally {
                self.view?.addDeviceConfiguration(self.deviceConfiguration)
            }
    }
}
