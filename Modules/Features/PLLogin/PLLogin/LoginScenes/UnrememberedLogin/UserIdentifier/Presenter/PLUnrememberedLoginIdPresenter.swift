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
    weak var loginManager: PLLoginLayersManagerDelegate?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension PLUnrememberedLoginIdPresenter: PLUnrememberedLoginIdPresenterProtocol {
    func viewDidLoad() {
        // TODO
    }
    
    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
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

extension PLUnrememberedLoginIdPresenter: PLLoginPresenterLayerProtocol {

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
