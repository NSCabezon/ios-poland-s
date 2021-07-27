//
//  PLHardwareTokenPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 20/7/21.
//

import Models
import Commons

protocol PLHardwareTokenPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLHardwareTokenViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func goToDeviceTrustDeviceData()
}

final class PLHardwareTokenPresenter {
    weak var view: PLHardwareTokenViewProtocol?
    weak var loginManager: PLLoginLayersManagerDelegate?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }

    private var globalPositionOptionUseCase: PLGetGlobalPositionOptionUseCase {
        return self.dependenciesResolver.resolve(for: PLGetGlobalPositionOptionUseCase.self)
    }

    private var getNextSceneUseCase: PLGetLoginNextSceneUseCase {
        return self.dependenciesResolver.resolve(for: PLGetLoginNextSceneUseCase.self)
    }
}

extension PLHardwareTokenPresenter: PLHardwareTokenPresenterProtocol {
    func didSelectLoginRestartAfterTimeOut() {
        // TODO
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
    }

    func goToDeviceTrustDeviceData() {
        self.coordinator.goToDeviceTrustDeviceData()
    }
}

//MARK: - Private Methods
private extension  PLHardwareTokenPresenter {
    var coordinator: PLHardwareTokenCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLHardwareTokenCoordinatorProtocol.self)
    }

    func getGlobalPositionTypeAndNavigate() {
        Scenario(useCase: self.globalPositionOptionUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess( { [weak self] output in
                guard let self = self else { return }
                self.goToGlobalPosition(output.globalPositionOption)
            })
            .onError { [weak self] _ in
                guard let self = self else { return }
                self.goToGlobalPosition(.classic)
            }
    }

    func goToGlobalPosition(_ option: GlobalPositionOptionEntity) {
        let coordinatorDelegate: PLLoginCoordinatorProtocol = self.dependenciesResolver.resolve(for: PLLoginCoordinatorProtocol.self)
        self.view?.dismissLoading()
        coordinatorDelegate.goToPrivate(option)
    }
}
