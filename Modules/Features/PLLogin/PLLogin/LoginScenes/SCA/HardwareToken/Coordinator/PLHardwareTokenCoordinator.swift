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

final class PLHardwareTokenCoordinator: ModuleCoordinator, PLScaAuthCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    var deviceDataCoordinator: PLDeviceDataCoordinator
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
/**
 #Register Scene depencencies.
*/
private extension PLHardwareTokenCoordinator {
    func setupDependencies() {
        let presenter = PLHardwareTokenPresenter(dependenciesResolver: self.dependenciesEngine)
        let authProcessUseCase = PLAuthProcessUseCase(dependenciesEngine: self.dependenciesEngine)
        
        self.dependenciesEngine.register(for: PLScaAuthCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLHardwareTokenPresenterProtocol.self) { resolver in
            return presenter
        }
           
        self.dependenciesEngine.register(for: PLAuthProcessUseCase.self) { _ in
            return authProcessUseCase
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
