//
//  PLNotificationsInboxModuleCoordinator.swift
//  PLNotificationsInbox
//

//PLNotificationsInboxModuleCoordinator

import UI
import Commons

final public class PLNotificationsInboxModuleCoordinator: ModuleCoordinator {
    
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let notificationsInboxListCoordinator: NotificationsInboxListCoordinator
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.notificationsInboxListCoordinator = NotificationsInboxListCoordinator(dependenciesResolver: dependenciesResolver, navigationController: navigationController)
        setupDependencies()
    }
    
    public func start() {
        notificationsInboxListCoordinator.start()
    }

}

private extension PLNotificationsInboxModuleCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: PLNotificationsInboxModuleCoordinator.self) { _ in
            return self
        }
    }
}
