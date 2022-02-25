//
//  PLNotificationsInboxModuleCoordinator.swift
//  PLNotificationsInbox
//

//PLNotificationsInboxModuleCoordinator

import UI
import CoreFoundationLib

final public class PLNotificationsInboxModuleCoordinator: ModuleCoordinator {
    
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    private lazy var notificationsUseCaseManager: PLNotificationsUseCaseManagerProtocol = {
        return PLNotificationsUseCaseManager(dependenciesEngine: dependenciesEngine)
    }()
    
    private var notificationsInboxListCoordinator: NotificationsInboxListCoordinator? = nil
    
    public init(dependenciesResolver: DependenciesResolver & DependenciesInjector, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = dependenciesResolver
        self.setupDependencies()
        self.notificationsInboxListCoordinator = NotificationsInboxListCoordinator(dependenciesResolver: dependenciesEngine, navigationController: navigationController)
        
    }
    
    public func start() {
        notificationsInboxListCoordinator?.start()
    }

}

private extension PLNotificationsInboxModuleCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: PLNotificationsInboxModuleCoordinator.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: PLNotificationsUseCaseManagerProtocol.self) { _ in
            return self.notificationsUseCaseManager
        }
    }
}
