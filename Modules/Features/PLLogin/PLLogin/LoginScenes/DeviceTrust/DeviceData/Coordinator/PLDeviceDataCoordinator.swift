//
//  PLDeviceDataController.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 16/6/21.
//

import Commons
import UI
import Models
import SANLegacyLibrary
import LoginCommon
import CommonUseCase

protocol PLDeviceDataCoordinatorProtocol {
    func goToGlobalPositionScene()
}

final class PLDeviceDataCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private lazy var loginLayerManager: PLLoginLayersManager = {
        return PLLoginLayersManager(dependenciesResolver: self.dependenciesEngine)
    }()

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLDeviceDataViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLDeviceDataCoordinator: PLDeviceDataCoordinatorProtocol {
    func goToGlobalPositionScene() {
        //TODO:
    }
}

/**
 #Register Scene depencencies.
*/
private extension PLDeviceDataCoordinator {
    func setupDependencies() {
        let presenter = PLDeviceDataPresenter(dependenciesResolver: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLDeviceDataCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLDeviceDataPresenterProtocol.self) { resolver in
            return presenter
        }

        self.dependenciesEngine.register(for: PLDeviceDataViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLDeviceDataViewController.self)
        }

        self.dependenciesEngine.register(for: PLLoginCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLDeviceDataViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLDeviceDataPresenterProtocol.self)
            let viewController = PLDeviceDataViewController(
                nibName: "PLDeviceDataViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            presenter.loginManager = self.loginLayerManager
            return viewController
        }

        self.dependenciesEngine.register(for: PullOfferCandidatesUseCase.self) { resolver in
           return PullOfferCandidatesUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: SetupPublicPullOffersSuperUseCase.self) { resolver in
           return SetupPublicPullOffersSuperUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: SetupPullOffersUseCase.self) { resolver in
           return SetupPullOffersUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: LoadPublicPullOffersVarsUseCase.self) { resolver in
           return LoadPublicPullOffersVarsUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: CalculateLocationsUseCase.self) { resolver in
           return CalculateLocationsUseCase(dependenciesResolver: resolver)
        }
        self.registerEnvironmentDependencies()
    }
}

extension PLDeviceDataCoordinator: PLLoginCoordinatorProtocol {}
extension PLDeviceDataCoordinator: LoginChangeEnvironmentResolverCapable {}
