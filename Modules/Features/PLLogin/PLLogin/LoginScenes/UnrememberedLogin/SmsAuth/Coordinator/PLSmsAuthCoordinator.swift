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
}

final class PLSmsAuthCoordinator: ModuleCoordinator {
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
        let controller = self.dependenciesEngine.resolve(for: PLSmsAuthViewController.self)
        self.navigationController?.pushViewController(controller, animated: false)
    }
}

extension PLSmsAuthCoordinator: PLSmsAuthCoordinatorProtocol {
    func goToGlobalPositionScene() {
        //TODO:
    }

    func goToUnrememberedLogindScene() {
        self.backToLogin()
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

        self.dependenciesEngine.register(for: PLLoginPresenterLayerProtocol.self) { _ in
            return presenter
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

extension PLSmsAuthCoordinator: PLLoginCoordinatorProtocol {}
extension PLSmsAuthCoordinator: LoginChangeEnvironmentResolverCapable {}
