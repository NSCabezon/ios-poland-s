//
//  NotificationsInboxListCoordinator.swift
//  NotificationsInbox
//

import UI
import Models
import Commons

protocol NotificationsInboxListCoordinatorProtocol: ModuleCoordinator {
    func goBack()
}

final class NotificationsInboxListCoordinator: NotificationsInboxListCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: NotificationsInboxListViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension NotificationsInboxListCoordinator {
    func setupDependencies() {
        let presenter = NotificationsInboxListPresenter(dependenciesResolver: dependenciesEngine)
        
        dependenciesEngine.register(for: NotificationsInboxListCoordinatorProtocol.self) { _ in
            self
        }

        dependenciesEngine.register(for: NotificationsInboxListPresenterProtocol.self) { resolver in
            presenter
        }

        dependenciesEngine.register(for: NotificationsInboxListViewController.self) { resolver in
            var presenter = resolver.resolve(for: NotificationsInboxListPresenterProtocol.self)
            let viewController = NotificationsInboxListViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }

    }
}
