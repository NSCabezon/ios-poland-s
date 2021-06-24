//
//  PLSmsAuthCoordinator.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import Commons
import UI
import Models
import SANLegacyLibrary
import LoginCommon
import CommonUseCase

protocol PLSmsAuthCoordinatorProtocol {
    func goToGlobalPositionScene()
    func goToUnrememberedLogindScene()
    func goToDeviceTrustDeviceData()
}

final class PLSmsAuthCoordinator: ModuleCoordinator {
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
        let controller = self.dependenciesEngine.resolve(for: PLSmsAuthViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLSmsAuthCoordinator: PLSmsAuthCoordinatorProtocol {
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
private extension PLSmsAuthCoordinator {
    func setupDependencies() {
        let presenter = PLSmsAuthPresenter(dependenciesResolver: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLSmsAuthCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLSmsAuthPresenterProtocol.self) { resolver in
            return presenter
        }

        self.dependenciesEngine.register(for: PLSmsAuthViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLSmsAuthViewController.self)
        }

        self.dependenciesEngine.register(for: PLLoginCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLSmsAuthViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLSmsAuthPresenterProtocol.self)
            let viewController = PLSmsAuthViewController(
                nibName: "PLSmsAuthViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            presenter.loginManager = self.loginLayerManager
            return viewController
        }

        self.dependenciesEngine.register(for: PLGetPersistedPubKeyUseCase.self) { resolver in
           return PLGetPersistedPubKeyUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLAuthenticateUseCase.self) { resolver in
           return PLAuthenticateUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLAuthenticateInitUseCase.self) { resolver in
           return PLAuthenticateInitUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLPasswordEncryptionUseCase.self) { resolver in
           return PLPasswordEncryptionUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLGetGlobalPositionOptionUseCase.self) { resolver in
            return PLGetGlobalPositionOptionUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLGetLoginNextSceneUseCase.self) { resolver in
            return PLGetLoginNextSceneUseCase(dependenciesResolver: resolver)
        }
        self.registerEnvironmentDependencies()
    }
}

extension PLSmsAuthCoordinator: PLLoginCoordinatorProtocol {}
extension PLSmsAuthCoordinator: LoginChangeEnvironmentResolverCapable {}
