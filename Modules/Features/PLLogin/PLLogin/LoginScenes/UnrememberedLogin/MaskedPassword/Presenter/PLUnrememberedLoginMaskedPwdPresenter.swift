//
//  PLUnrememberedLoginMaskedPwdPresenter.swift
//  PLLogin

import DomainCommon
import Commons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter
import PLUI

protocol PLUnrememberedLoginMaskedPwdPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLUnrememberedLoginMaskedPwdViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func login(password: String)
    func viewDidLoad()
    func viewWillAppear()
    func recoverPasswordOrNewRegistration()
    func didSelectChooseEnvironment()
    func requestedPositions() -> [Int]
}

final class PLUnrememberedLoginMaskedPwdPresenter {
    weak var view: PLUnrememberedLoginMaskedPwdViewProtocol?
    weak var loginManager: PLLoginLayersManagerDelegate?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }
}

extension PLUnrememberedLoginMaskedPwdPresenter: PLUnrememberedLoginMaskedPwdPresenterProtocol {
    func viewDidLoad() {
        self.view?.setUserIdentifier(loginConfiguration.userIdentifier)

        if let imageString = loginConfiguration.loginImageData,
           let data = Data(base64Encoded: imageString),
           let image = UIImage(data: data) {
            self.view?.setUserImage(image: image)
        }
    }

    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
    }

    func login(password: String) {
        self.loginConfiguration.password = password
        self.coordinator.goToSMSScene()
    }

    func recoverPasswordOrNewRegistration() {
        // TODO
    }

    func didSelectChooseEnvironment() {
        // TODO
    }

    // Returns [Int] with the positions requested for the masked password
    func requestedPositions() -> [Int] {

        var maskValue: Int = 0
        if case .masked(mask: let value) = self.loginConfiguration.passwordType {
            maskValue = value + 1048576
        }

        let binaryString = String(maskValue, radix: 2).reversed()
        var pos = 0
        let requestedPositions: [Int] = binaryString.compactMap {
            let value = Int(String($0)) ?? 0
            pos += 1
            guard pos <= 20 else { return nil }
            return value == 1 ? pos : nil
        }
        return requestedPositions
    }
}

extension PLUnrememberedLoginMaskedPwdPresenter: PLLoginPresenterLayerProtocol {

    func handle(event: LoginProcessLayerEvent) {
        // TODO
    }

    func handle(event: SessionProcessEvent) {
        // TODO
    }

    func didLoadEnvironment(_ environment: PLEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity) {
        self.publicFilesEnvironment = publicFilesEnvironment
        let wsViewModel = EnvironmentViewModel(title: environment.name, url: environment.urlBase)
        let publicFilesViewModel = EnvironmentViewModel(title: publicFilesEnvironment.name, url: publicFilesEnvironment.urlBase)
        self.view?.updateEnvironmentsText([wsViewModel, publicFilesViewModel])
    }

    func willStartSession() {
        // TODO
    }
}

//MARK: - Private Methods
private extension  PLUnrememberedLoginMaskedPwdPresenter {
    var coordinator: PLUnrememberedLoginMaskedPwdCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLUnrememberedLoginMaskedPwdCoordinatorProtocol.self)
    }
}
