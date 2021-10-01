//
//  PLUnrememberedLoginOnboardingCoordinator.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 20/9/21.
//

import Foundation
import UI
import Commons

protocol PLUnrememberedLoginOnboardingCoordinatorProtocol {
    func didSelectLogin()
    func didSelectCreateAccount()
}

final class PLUnrememberedLoginOnboardingCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private lazy var unrememberdLoginIdCoordinator: PLUnrememberedLoginIdCoordinator = {
        return PLUnrememberedLoginIdCoordinator(dependenciesResolver: dependenciesEngine, navigationController: navigationController)
    }()
    
    private lazy var isFirstLaunchUseCase: PLFirstLaunchUseCase = {
        return PLFirstLaunchUseCase(dependenciesResolver: dependenciesEngine)
    }()
    
    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLUnrememberedLoginOnboardingViewController.self)
        self.navigationController?.setViewControllers([controller], animated: false)
    }
}

// MARK: Register Scene depencencies.
private extension PLUnrememberedLoginOnboardingCoordinator {
    func setupDependencies() {
        let presenter = PLUnrememberedLoginOnboardingPresenter(dependenciesResolver: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLUnrememberedLoginOnboardingProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLUnrememberedLoginOnboardingViewController.self)
        }
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginOnboardingPresenter.self) { resolver in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginOnboardingCoordinatorProtocol.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginOnboardingViewController.self) { resolver in
            let viewController = PLUnrememberedLoginOnboardingViewController(
                nibName: "PLUnrememberedLoginOnboardingViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

extension PLUnrememberedLoginOnboardingCoordinator : PLUnrememberedLoginOnboardingCoordinatorProtocol {
    func didSelectLogin() {
        Scenario(useCase: self.isFirstLaunchUseCase,
                 input: PLFirstLaunchUseCaseInput(shouldSetFirstLaunch: true)).execute(on: self.dependenciesEngine.resolve())
        unrememberdLoginIdCoordinator.start()
    }
    
    func didSelectCreateAccount() {
        Scenario(useCase: self.isFirstLaunchUseCase,
                 input: PLFirstLaunchUseCaseInput(shouldSetFirstLaunch: true)).execute(on: self.dependenciesEngine.resolve())
        //TODO: Open create account webview here
    }
}
