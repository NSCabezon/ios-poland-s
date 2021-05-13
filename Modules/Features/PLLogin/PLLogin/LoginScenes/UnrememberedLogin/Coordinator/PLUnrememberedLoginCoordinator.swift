//
//  PLUnrememberedLoginCoordinator.swift
//  PLLogin

import Commons
import UI
import Models
import SANLegacyLibrary
import LoginCommon
import CommonUseCase

public class PLUnrememberedLoginCoordinator: ModuleCoordinator {
    public var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private lazy var loginLayerManager: PLLoginLayerManager = {
        return PLLoginLayerManager(dependenciesResolver: self.dependenciesEngine)
    }()
    private var loginModuleCoordinator: LoginModuleCoordinatorProtocol {
        return self.dependenciesEngine.resolve(for: LoginModuleCoordinatorProtocol.self)
    }
    
    public init(dependenciesEngine: DependenciesResolver & DependenciesInjector, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesEngine)
        self.setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: PLUnrememberedLoginViewController.self)
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    private func setupDependencies() {
        let presenter = PLUnrememberedLoginPresenter(dependenciesResolver: self.dependenciesEngine)
        self.dependenciesEngine.register(for: PLUnrememberedLoginPresenterProtocol.self) { _ in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLLoginPresenterLayerProtocol.self) { _ in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLUnrememberedLoginViewController.self)
        }
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginViewController.self) { dependenciesResolver in
            var presenter: PLUnrememberedLoginPresenterProtocol = dependenciesResolver.resolve(for: PLUnrememberedLoginPresenterProtocol.self)
            let viewController = PLUnrememberedLoginViewController(nibName: "PLUnrememberedLoginViewController", bundle: Bundle.module, dependenciesResolver: dependenciesResolver, presenter: presenter)
            presenter.view = viewController
            presenter.loginManager = self.loginLayerManager
            return viewController
        }
        
        // TODO: register other dependencies: use case...

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
