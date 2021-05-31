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
    func login(identification: String)
    func recoverPasswordOrNewRegistration()
    func didSelectChooseEnvironment()
}

final class PLSmsAuthPresenter {
    weak var view: PLSmsAuthViewProtocol?
    weak var loginManager: PLLoginLayersManagerDelegate?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension PLSmsAuthPresenter: PLSmsAuthPresenterProtocol {
    func viewDidLoad() {
        // TODO
    }

    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
    }

    func login(identification: String) {
        self.doLogin(with: .notPersisted(info: LoginTypeInfo(identification: identification)))
    }

    func recoverPasswordOrNewRegistration() {
        // TODO
    }

    func didSelectChooseEnvironment() {
        // TODO
    }
}

extension PLSmsAuthPresenter: PLLoginPresenterLayerProtocol {
    func handle(event: LoginProcessLayerEvent) {
        switch event {
        case .willLogin:
            break // TODO
        case .loginWithIdentifierSuccess(let _):
            break // TODO
        case .loginSuccess:
            break // TODO
        case .noConnection:
            break // TODO
        case .loginError:
            break // TODO
        }
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

    func doLogin(with type: LoginType) {
        self.view?.showLoadingWithInfo(completion: {[weak self] in
            self?.loginManager?.doLogin(type: type)
        })
    }
}
