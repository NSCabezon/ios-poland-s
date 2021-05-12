//
//  PLUnrememberedLoginPresenter.swift
//  PLLogin

import DomainCommon
import Commons
import Models
import LoginCommon
import SANPLLibrary

protocol PLUnrememberedLoginPresenterProtocol {
    var view: PLUnrememberedLoginViewProtocol? { get set }
    var loginManager: PLLoginManagerProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func login(identification: String, magic: String, remember: Bool)
    func recoverPasswordOrNewRegistration()
    func didSelectChooseEnvironment()
}

final class PLUnrememberedLoginPresenter {
    weak var view: PLUnrememberedLoginViewProtocol?
    weak var loginManager: PLLoginManagerProtocol?
    let dependenciesResolver: DependenciesResolver
    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }
    
    init(dependenciesResolver: DependenciesResolver) {
            self.dependenciesResolver = dependenciesResolver
    }
}

extension PLUnrememberedLoginPresenter: PLUnrememberedLoginPresenterProtocol {
    func viewDidLoad() {
        // TODO
    }
    
    func viewWillAppear() {
        // TODO
    }
    
    func login(identification: String, magic: String, remember: Bool) {
        // TODO
    }
    
    func recoverPasswordOrNewRegistration() {
        // TODO
    }
    
    func didSelectChooseEnvironment() {
        // TODO
    }
    
}
