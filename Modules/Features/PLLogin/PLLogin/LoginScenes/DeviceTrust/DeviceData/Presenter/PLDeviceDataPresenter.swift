//
//  PLDeviceDataPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 16/6/21.
//

import DomainCommon
import Commons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter

protocol PLDeviceDataPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLDeviceDataViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func didSelectChooseEnvironment()
}

final class PLDeviceDataPresenter {
    weak var view: PLDeviceDataViewProtocol?
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

extension PLDeviceDataPresenter: PLDeviceDataPresenterProtocol {
    func viewDidLoad() {
        // TODO
    }

    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
    }

    func didSelectChooseEnvironment() {
        // TODO
    }
}

//MARK: - Private Methods
private extension  PLDeviceDataPresenter {
    var coordinator: PLDeviceDataCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLDeviceDataCoordinatorProtocol.self)
    }

    func doAuthenticateInit() {
        self.loginManager?.doAuthenticateInit()
    }

    func doAuthenticate() {
        self.loginManager?.doAuthenticate()
    }
}
