//
//  PLUnrememberedLoginIdPresenter.swift
//  PLLogin

import DomainCommon
import Commons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter

protocol PLUnrememberedLoginIdPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLUnrememberedLoginIdViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func login(identification: String)
    func recoverPasswordOrNewRegistration()
    func didSelectChooseEnvironment()
}

final class PLUnrememberedLoginIdPresenter {
    weak var view: PLUnrememberedLoginIdViewProtocol?
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

extension PLUnrememberedLoginIdPresenter: PLUnrememberedLoginIdPresenterProtocol {
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
        self.coordinatorDelegate.goToEnvironmentsSelector { [weak self] in
            self?.loginManager?.chooseEnvironment()
        }
    }
}

extension PLUnrememberedLoginIdPresenter: PLLoginPresenterLayerProtocol {
    func handle(event: LoginProcessLayerEvent) {
        switch event {
        case .willLogin:
            break // TODO
        case .loginWithIdentifierSuccess(let configuration):
            self.view?.dismissLoading(completion: { [weak self] in
                switch configuration.passwordType {
                case .normal:
                    self?.coordinator.goToNormalPasswordScene(configuration: configuration)
                case .masked:
                    self?.coordinator.goToMaskedPasswordScene(configuration: configuration)
                }
            })

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
private extension  PLUnrememberedLoginIdPresenter {
    var coordinator: PLUnrememberedLoginIdCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLUnrememberedLoginIdCoordinatorProtocol.self)
    }
    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }

    func doLogin(with type: LoginType) {
        self.view?.showLoadingWithInfo(completion: {[weak self] in
            self?.loginManager?.doLogin(type: type)
        })
    }
}