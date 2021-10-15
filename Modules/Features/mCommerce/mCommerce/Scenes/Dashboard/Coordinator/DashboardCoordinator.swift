//
//  DashboardCoordinator.swift
//  mCommerce
//

import UI
import Models
import Commons

protocol DashboardCoordinatorProtocol: ModuleCoordinator {
    func goBack()
}

final class DashboardCoordinator: DashboardCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: DashboardViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension DashboardCoordinator {
    func setupDependencies() {
        let presenter = DashboardPresenter(dependenciesResolver: dependenciesEngine)
        
        dependenciesEngine.register(for: DashboardCoordinatorProtocol.self) { _ in
            self
        }

        dependenciesEngine.register(for: DashboardPresenterProtocol.self) { resolver in
            presenter
        }

        dependenciesEngine.register(for: DashboardViewController.self) { resolver in
            var presenter = resolver.resolve(for: DashboardPresenterProtocol.self)
            let viewController = DashboardViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }

    }
}
