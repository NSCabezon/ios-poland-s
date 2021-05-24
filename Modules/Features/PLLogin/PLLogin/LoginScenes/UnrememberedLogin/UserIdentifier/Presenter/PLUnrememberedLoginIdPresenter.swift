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
    func login(identification: String, magic: String, remember: Bool)
    func recoverPasswordOrNewRegistration()
    func didSelectChooseEnvironment()
}

final class PLUnrememberedLoginIdPresenter {
    weak var view: PLUnrememberedLoginIdViewProtocol?
    weak var loginManager: PLLoginManagerProtocol?
    internal let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        let managersProviders = dependenciesResolver.resolve(for: PLManagersProviderAdapterProtocol.self)
        let managerProvider = managersProviders.getPLManagerProvider()
        self.loginManager = managerProvider.getLoginManager()
    }
}

extension PLUnrememberedLoginIdPresenter: PLUnrememberedLoginIdPresenterProtocol {
    func viewDidLoad() {
        // TODO
    }
    
    func viewWillAppear() {
        // TODO
    }
    
    func login(identification: String, magic: String, remember: Bool) {
        // TODO: Check if this is the appropiate place for this example or we need an intermediate use case
        let parameters = LoginParameters(userId: "33355343", userAlias: nil)
        let result = try? self.loginManager?.doLogin(parameters)
        switch result {
        case .success(let login):
            print("success")
        case .failure(let error):
            print("login failed")
        default:
            print("Default")
        }
    }
    
    func recoverPasswordOrNewRegistration() {
        // TODO
    }
    
    func didSelectChooseEnvironment() {
        // TODO
    }
}

extension PLUnrememberedLoginIdPresenter: PLLoginPresenterLayerProtocol {

    func handle(event: SessionProcessEvent) {
        // TODO
    }
    func willStartSession() {
        // TODO
    }
}
