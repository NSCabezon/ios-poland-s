//
//  PLUnrememberedLoginNormalPwdPresenter.swift
//  PLLogin

import DomainCommon
import Commons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter

protocol PLUnrememberedLoginNormalPwdPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLUnrememberedLoginNormalPwdViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func goToSMSScene()
    func recoverPasswordOrNewRegistration()
    func didSelectChooseEnvironment()
}

final class PLUnrememberedLoginNormalPwdPresenter {
    weak var view: PLUnrememberedLoginNormalPwdViewProtocol?
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

extension PLUnrememberedLoginNormalPwdPresenter: PLUnrememberedLoginNormalPwdPresenterProtocol {
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

    func goToSMSScene() {
        self.coordinator.goToSMSScene()
    }

    func recoverPasswordOrNewRegistration() {
        // TODO
    }

    func didSelectChooseEnvironment() {
        // TODO
    }
}

extension PLUnrememberedLoginNormalPwdPresenter: PLLoginPresenterLayerProtocol {
    func handle(event: LoginProcessLayerEvent) {
        // TODO
    }

    func handle(event: SessionProcessEvent) {
        // TODO
    }
    func willStartSession() {
        // TODO
    }

    func didLoadEnvironment(_ environment: PLEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity) {
        self.publicFilesEnvironment = publicFilesEnvironment
        let wsViewModel = EnvironmentViewModel(title: environment.name, url: environment.urlBase)
        let publicFilesViewModel = EnvironmentViewModel(title: publicFilesEnvironment.name, url: publicFilesEnvironment.urlBase)
        self.view?.updateEnvironmentsText([wsViewModel, publicFilesViewModel])
    }
}

//MARK: - Private Methods
private extension  PLUnrememberedLoginNormalPwdPresenter {
    var coordinator: PLUnrememberedLoginNormalPwdCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLUnrememberedLoginNormalPwdCoordinatorProtocol.self)
    }
}