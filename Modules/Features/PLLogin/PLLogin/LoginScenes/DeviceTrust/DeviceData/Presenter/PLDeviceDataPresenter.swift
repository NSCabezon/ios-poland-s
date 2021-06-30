//
//  PLDeviceDataPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 16/6/21.
//

import DomainCommon
import Commons
import Models

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

        let model = UIDevice.current.getDeviceName()//UIDevice.current.getDeviceName().components(separatedBy: " ")[1]
        let brand = Constants.manufacturer//UIDevice.current.model
        let deviceId = PLLoginTrustedDeviceHelpers.secureRandom(bytesNumber: 9)?.toHexString() ?? ""
        let appId = Constants.oneApp + deviceId

        return TrustedDeviceConfiguration(manufacturer: Constants.manufacturer,
                                          model: model,
                                          brand: brand,
                                          appId: appId,
                                          deviceId: deviceId)
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

    private lazy var parameters: String = {
        let dateString = self.parametersDateFormatter.string(from: self.currentDate)
        let appId = self.deviceConfiguration.appId
        let deviceId = self.deviceConfiguration.deviceId
        let manufacturer = self.deviceConfiguration.manufacturer
        let model = self.deviceConfiguration.model
        let parameters = "<\(dateString)><<AppId><\(appId)><deviceId><\(deviceId)><manufacturer><\(manufacturer)><model><\(model)>>"
        return parameters
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
            return
        }

        let transportKeyEncryptionUseCaseInput = PLDeviceDataTransportKeyEncryptionUseCaseInput(transportKey: self.transportKey,
                                                                                                passKey: password)
        let trasportKeyScenario = Scenario(useCase: self.transportKeyEncryptionUseCase, input: transportKeyEncryptionUseCaseInput)

        let parametersEncryptionUseCaseInput = PLDeviceDataParametersEncryptionUseCaseInput(parameters: self.parameters,
                                                                                            transportKey: transportKey)
        let parametersScenario = Scenario(useCase: self.parametersEncryptionUseCase, input: parametersEncryptionUseCaseInput)

        let certificateCreationUseCaseInput = PLDeviceDataCertificateCreationUseCaseInput()
        let certificateScenario = Scenario(useCase: self.certificatCreationUseCase, input: certificateCreationUseCaseInput)

        let values: (transportKeyEncryption: String?, parametersEncryption: String?, publicKey: String?) = (nil, nil, nil)
        MultiScenario(handledOn: self.dependenciesResolver.resolve(), initialValue: values)
            .addScenario(trasportKeyScenario) { (updatedValues, output, _) in
                updatedValues.transportKeyEncryption = output.encryptedTransportKey
            }.addScenario(parametersScenario) { (updatedValues, output, _) in
                updatedValues.parametersEncryption = output.encryptedParameters
            }.addScenario(certificateScenario) { (updatedValues, output, _) in
                updatedValues.publicKey = output.certificate
            }.then(scenario: { (transportKeyEncryption, parametersEncryption, certificate) -> Scenario<PLDeviceDataRegisterDeviceUseCaseInput, PLDeviceDataRegisterDeviceUseCaseOutput, PLDeviceDataUseCaseErrorOutput> in
                let registerDeviceUseCaseInput = PLDeviceDataRegisterDeviceUseCaseInput(transportKey: transportKeyEncryption ?? "",
                                                                                        deviceParameters: parametersEncryption ?? "",
                                                                                        deviceTime: self.dateFormatter.string(from: self.currentDate),
                                                                                        certificate: certificate ?? "",
                                                                                        appId: self.deviceConfiguration.appId)
                let registerDeviceScenario = Scenario(useCase: self.registerDeviceUseCase, input: registerDeviceUseCaseInput)
                return registerDeviceScenario
            })
            .onSuccess { [weak self] registerDeviceOutput in
                guard let self = self else { return }
                // TODO: We need to save registeredDeviceOutput
                self.goToTrustedDevicePIN()
            }.onError { _ in
                // TODO: Handle error
            }
    }

    func goToTrustedDevicePIN() {
        coordinator.goToTrustedDevicePIN()
    }
}
