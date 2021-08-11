//
//  PLDeviceDataPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 16/6/21.
//

import DomainCommon
import Commons
import Models
import os

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

    private enum Constants {
        static let oneApp = "OneApp"
        static let manufacturer = "Apple"
    }

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

    var coordinator: PLDeviceDataCoordinatorProtocol {
        self.dependenciesResolver.resolve(for: PLDeviceDataCoordinatorProtocol.self)
    }

    private lazy var deviceConfiguration: TrustedDeviceConfiguration = {
        let model = UIDevice.current.getDeviceName()
        let brand = Constants.manufacturer
        let deviceId = PLLoginTrustedDeviceHelpers.secureRandom(bytesNumber: 9)?.toHexString() ?? ""
        let appId = Constants.oneApp + deviceId
        let manufacturer = Constants.manufacturer
        let dateString = self.parametersDateFormatter.string(from: self.currentDate)
        let parameters = "<\(dateString)><AppId><\(appId)><deviceId><\(deviceId)><manufacturer><\(manufacturer)><model><\(model)>"
        let deviceTime = self.dateFormatter.string(from: self.currentDate)

        let deviceData = TrustedDeviceConfiguration.DeviceData(manufacturer: manufacturer,
                                                               model: model,
                                                               brand: brand,
                                                               appId: appId,
                                                               deviceId: deviceId,
                                                               deviceTime: deviceTime,
                                                               parameters: parameters)

        return TrustedDeviceConfiguration(deviceData: deviceData,
                                          softwareToken: nil)
    }()

    private lazy var currentDate: Date = {
        return Date()
    }()

    // We need to use different formats for both dates we are sending
    private var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return df
    }()

    private var parametersDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return df
    }()

    private lazy var transportKey: String = {
        return PLLoginTrustedDeviceHelpers.secureRandom(bytesNumber: 16)?.toHexString() ?? ""
    }()
}

extension PLDeviceDataPresenter: PLDeviceDataPresenterProtocol {

    func viewDidLoad() {
        view?.addDeviceConfiguration(self.deviceConfiguration)
    }

    func viewWillAppear() {
    }

    func registerDevice() {

        guard let password = loginConfiguration.password else {
            // TODO: generate error, password can't be empty
            // And more important, create a tustedDevieConfiguration for not using the one from loginConfiguration
            return
        }

        let transportKeyEncryptionUseCaseInput = PLDeviceDataTransportKeyEncryptionUseCaseInput(transportKey: self.transportKey,
                                                                                                passKey: password)
        let trasportKeyScenario = Scenario(useCase: self.transportKeyEncryptionUseCase, input: transportKeyEncryptionUseCaseInput)

        let parametersEncryptionUseCaseInput = PLDeviceDataParametersEncryptionUseCaseInput(parameters: self.deviceConfiguration.deviceData.parameters,
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
            }.then(scenario: { (transportKeyEncryption, parametersEncryption, certificate, key) -> Scenario<PLDeviceDataRegisterDeviceUseCaseInput, PLDeviceDataRegisterDeviceUseCaseOutput, PLDeviceDataUseCaseErrorOutput> in
                let registerDeviceUseCaseInput = PLDeviceDataRegisterDeviceUseCaseInput(transportKey: transportKeyEncryption ?? "",
                                                                                        deviceParameters: parametersEncryption ?? "",
                                                                                        deviceTime: self.deviceConfiguration.deviceData.deviceTime,
                                                                                        certificate: certificate ?? "",
                                                                                        appId: self.deviceConfiguration.deviceData.appId)

                let softwareToken = TrustedDeviceConfiguration.SoftwareToken(privateKey: key,
                                                                             certificatePEM: certificate)
                self.deviceConfiguration.softwareToken = softwareToken

                return Scenario(useCase: self.registerDeviceUseCase, input: registerDeviceUseCaseInput)
            })
            .onSuccess { [weak self] registerSoftwareTokenOutput in
                guard let self = self else { return }
                self.goToTrustedDevicePIN()
            }.onError { _ in
                // TODO: Handle error
            }
    }

    func goToTrustedDevicePIN() {
        coordinator.goToTrustedDevicePIN(with: self.deviceConfiguration)
    }
}
