//
//  PLHardwareTokenCoordinator.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 20/7/21.
//

import Commons
import UI
import Models
import SANLegacyLibrary
import LoginCommon
import CommonUseCase

protocol PLHardwareTokenCoordinatorProtocol {
    func goToGlobalPositionScene()
    func goToUnrememberedLogindScene()
    func goToDeviceTrustDeviceData()
}

final class PLHardwareTokenCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let deviceDataCoordinator: PLDeviceDataCoordinator
    private lazy var loginLayerManager: PLLoginLayersManager = {
        return PLLoginLayersManager(dependenciesResolver: self.dependenciesEngine)
    }()

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.deviceDataCoordinator = PLDeviceDataCoordinator(
            dependenciesResolver: self.dependenciesEngine,
            navigationController: navigationController
        )
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLHardwareTokenViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLHardwareTokenCoordinator: PLHardwareTokenCoordinatorProtocol {
    func goToGlobalPositionScene() {
        //TODO:
    }

    func goToUnrememberedLogindScene() {
        self.backToLogin()
    }

    func goToDeviceTrustDeviceData() {
        self.deviceDataCoordinator.start()
    }
}

/**
 #Register Scene depencencies.
*/
private extension PLHardwareTokenCoordinator {
    func setupDependencies() {
        let presenter = PLHardwareTokenPresenter(dependenciesResolver: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLHardwareTokenCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLHardwareTokenPresenterProtocol.self) { resolver in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLGetPersistedPubKeyUseCase.self) { resolver in
           return PLGetPersistedPubKeyUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLAuthenticateUseCase.self) { resolver in
           return PLAuthenticateUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLPasswordEncryptionUseCase.self) { resolver in
           return PLPasswordEncryptionUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLGetLoginNextSceneUseCase.self) { resolver in
            return PLGetLoginNextSceneUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLHardwareTokenViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLHardwareTokenViewController.self)
        }

        self.dependenciesEngine.register(for: PLLoginCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLHardwareTokenViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLHardwareTokenPresenterProtocol.self)
            let viewController = PLHardwareTokenViewController(
                nibName: "PLHardwareTokenViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            presenter.loginManager = self.loginLayerManager
            return viewController
        }
    }
}

extension PLHardwareTokenCoordinator: PLLoginCoordinatorProtocol {}
