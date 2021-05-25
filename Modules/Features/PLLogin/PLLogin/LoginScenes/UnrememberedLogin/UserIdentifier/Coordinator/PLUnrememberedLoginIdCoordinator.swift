//
//  PLUnrememberedLoginIdCoordinator.swift
//  PLLogin

import Commons
import UI
import Models
import SANLegacyLibrary
import LoginCommon
import CommonUseCase

protocol PLUnrememberedLoginIdCoordinatorProtocol {
    func goToNormalLoginScene()
    func goToMaskedLoginScene()
}

final class PLUnrememberedLoginIdCoordinator: ModuleCoordinator {
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
        let controller = self.dependenciesEngine.resolve(for: PLUnrememberedLoginIdViewController.self)
        self.navigationController?.pushViewController(controller, animated: false)
    }
}

extension PLUnrememberedLoginIdCoordinator: PLUnrememberedLoginIdCoordinatorProtocol {
    func goToNormalLoginScene() {
        //TODO:
    }
    
    func goToMaskedLoginScene() {
        //TODO:
    }
}

/**
 #Register Scene depencencies.
*/
private extension PLUnrememberedLoginIdCoordinator {
    func setupDependencies() {
        let presenter = PLUnrememberedLoginIdPresenter(dependenciesResolver: self.dependenciesEngine)
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginIdCoordinatorProtocol.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: PLLoginPresenterLayerProtocol.self) { _ in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginIdPresenterProtocol.self) { resolver in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginIdViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLUnrememberedLoginIdViewController.self)
        }

        self.dependenciesEngine.register(for: PLLoginCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginIdViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLUnrememberedLoginIdPresenterProtocol.self)
            let viewController = PLUnrememberedLoginIdViewController(
                nibName: "PLUnrememberedLoginIdViewController",
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

extension PLUnrememberedLoginIdCoordinator: PLLoginCoordinatorProtocol {
    // TODO: override navigation methods if necessary
}

extension PLUnrememberedLoginIdCoordinator: LoginChangeEnvironmentResolverCapable {}
