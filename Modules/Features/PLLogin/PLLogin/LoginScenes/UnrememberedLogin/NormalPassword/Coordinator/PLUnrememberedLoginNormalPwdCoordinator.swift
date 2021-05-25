//
//  PLUnrememberedLoginNormalPwdCoordinator.swift
//  PLLogin

import Commons
import UI
import Models
import SANLegacyLibrary
import LoginCommon
import CommonUseCase

protocol PLUnrememberedLoginNormalPwdCoordinatorProtocol {
    func goToSMSScene()
}

final class PLUnrememberedLoginNormalPwdCoordinator: ModuleCoordinator {
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
        let controller = self.dependenciesEngine.resolve(for: PLUnrememberedLoginNormalPwdViewController.self)
        self.navigationController?.pushViewController(controller, animated: false)
    }
}

extension PLUnrememberedLoginNormalPwdCoordinator: PLUnrememberedLoginNormalPwdCoordinatorProtocol {
    func goToSMSScene() {
        // TODO
    }
}

/**
 #Register Scene depencencies.
*/
private extension PLUnrememberedLoginNormalPwdCoordinator {
    func setupDependencies() {
        let presenter = PLUnrememberedLoginNormalPwdPresenter(dependenciesResolver: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLUnrememberedLoginNormalPwdCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLLoginPresenterLayerProtocol.self) { _ in
            return presenter
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginNormalPwdPresenterProtocol.self) { resolver in
            return presenter
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginNormalPwdViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLUnrememberedLoginNormalPwdViewController.self)
        }

        self.dependenciesEngine.register(for: PLLoginCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginNormalPwdViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLUnrememberedLoginNormalPwdPresenterProtocol.self)
            let viewController = PLUnrememberedLoginNormalPwdViewController(
                nibName: "PLUnrememberedLoginNormalPwdViewController",
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
    }
}

extension PLUnrememberedLoginNormalPwdCoordinator: PLLoginCoordinatorProtocol {
    // TODO: override navigation methods if necessary
}
