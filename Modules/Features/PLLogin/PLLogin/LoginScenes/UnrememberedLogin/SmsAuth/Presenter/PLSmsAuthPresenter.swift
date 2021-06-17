//
//  PLSmsAuthPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import DomainCommon
import Commons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter

protocol PLSmsAuthPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLSmsAuthViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func authenticateInit()
    func authenticate()
    func recoverPasswordOrNewRegistration()
    func didSelectChooseEnvironment()
    func goToUnrememberedLogindScene()
}

final class PLSmsAuthPresenter {
    weak var view: PLSmsAuthViewProtocol?
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

extension PLSmsAuthPresenter: PLSmsAuthPresenterProtocol {
    func viewDidLoad() {
        // TODO
    }

    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
    }

    func authenticateInit() {
        self.doAuthenticateInit()
    }

    func authenticate() {
        self.coordinator.goToDeviceData()
        //self.doAuthenticate()
    }

    func recoverPasswordOrNewRegistration() {
        // TODO
    }

    func didSelectChooseEnvironment() {
        // TODO
    }

    func goToUnrememberedLogindScene() {
        self.coordinator.goToUnrememberedLogindScene()
    }
}

extension PLSmsAuthPresenter: PLLoginPresenterLayerProtocol {
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
private extension  PLSmsAuthPresenter {
    var coordinator: PLSmsAuthCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLSmsAuthCoordinatorProtocol.self)
    }

    func doAuthenticateInit() {
        self.loginManager?.doAuthenticateInit()
    }

    func doAuthenticate() {
        self.loginManager?.doAuthenticate()
    }
}
