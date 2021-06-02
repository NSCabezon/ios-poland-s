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
    func viewDidLoad()
    func viewWillAppear()
    func login(identification: String, magic: String, remember: Bool)
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

    // Returns [Int] with the positions requested for the masked password
    func requestedPositions() -> [Int] {

        var maskValue: Int = 0
        if case .masked(mask: let value) = self.loginConfiguration.passwordType {
            maskValue = value
        }

        let binaryString = String(maskValue, radix: 2)
        var pos = 0
        let requestedPositions: [Int] = binaryString.compactMap {
            let value = Int(String($0)) ?? 0
            pos += 1
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
    var coordinator: PLLoginCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLLoginCoordinatorProtocol.self)
    }
}
