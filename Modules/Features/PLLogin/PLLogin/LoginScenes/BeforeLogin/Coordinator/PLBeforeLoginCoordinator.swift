//
//  PLBeforeLoginCoordinator.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 27/9/21.
//

import Foundation
import UI
import Commons

protocol PLBeforeLoginCoordinatorProtocol {
    func loadUnrememberedLogin()
    func loadRememberedLogin(configuration: RememberedLoginConfiguration)
}

final class PLBeforeLoginCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLBeforeLoginViewController.self)
        self.navigationController?.setViewControllers([controller], animated: false)
    }
}

// MARK: Register Scene depencencies.
private extension PLBeforeLoginCoordinator {
    func setupDependencies() {
        let presenter = PLBeforeLoginPresenter(dependenciesResolver: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLBeforeLoginViewControllerProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLBeforeLoginViewController.self)
        }
        
        self.dependenciesEngine.register(for: PLBeforeLoginPresenterProtocol.self) { resolver in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLBeforeLoginCoordinatorProtocol.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: PLBeforeLoginUseCase.self) { resolver in
            return PLBeforeLoginUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLValidateVersionUseCase.self) { resolver in
            return PLValidateVersionUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLBeforeLoginViewController.self) { resolver in
            let viewController = PLBeforeLoginViewController(
                nibName: "PLBeforeLoginViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

extension PLBeforeLoginCoordinator : PLBeforeLoginCoordinatorProtocol {
    
    func loadUnrememberedLogin() {
        let loginModuleCoordinator = self.dependenciesEngine.resolve(for: PLLoginModuleCoordinatorProtocol.self)
        loginModuleCoordinator.loadUnrememberedLogin()
    }
    
    func loadRememberedLogin(configuration: RememberedLoginConfiguration) {
        let loginModuleCoordinator = self.dependenciesEngine.resolve(for: PLLoginModuleCoordinatorProtocol.self)
        loginModuleCoordinator.loadRememberedLogin(configuration: configuration)
    }
}
