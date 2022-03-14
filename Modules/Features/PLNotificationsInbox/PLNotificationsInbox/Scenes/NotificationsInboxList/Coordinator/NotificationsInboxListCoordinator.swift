//
//  NotificationsInboxListCoordinator.swift
//  NotificationsInbox
//

import UI
import CoreFoundationLib
import SANPLLibrary

protocol NotificationsInboxListCoordinatorProtocol: ModuleCoordinator {
    func goBack()
    func showFilterViewController(_ filters: [EnabledPushCategorie], _ statuses: [NotificationStatus])
}

final class NotificationsInboxListCoordinator {
    var delegate: NotificationsInboxListViewControllerDelegate?
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    var filterCoordinator: NotificationsFilterCoordinator?
    
    init(dependenciesResolver: DependenciesResolver & DependenciesInjector, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = dependenciesResolver
        self.setupDependencies(dependenciesResolver: dependenciesResolver)
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: NotificationsInboxListViewController.self)
        self.delegate = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension NotificationsInboxListCoordinator: NotificationsInboxListCoordinatorProtocol {
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func showFilterViewController(_ filters: [EnabledPushCategorie], _ statuses: [NotificationStatus]) {
        filterCoordinator?.selectedFilters = filters
        filterCoordinator?.selectedStatuses = statuses
        filterCoordinator?.start()
    }
}

/**
 #Register Scene depencencies.
 */

extension NotificationsInboxListCoordinator: NotificationsFilterCoordinatorResultDelegate {
    
    func setupDependencies(dependenciesResolver: DependenciesResolver) {
        let presenter = NotificationsInboxListPresenter(dependenciesResolver: dependenciesEngine)
        
        dependenciesEngine.register(for: NotificationsInboxListCoordinatorProtocol.self) { _ in
            self
        }
        
        dependenciesEngine.register(for: NotificationsInboxListPresenterProtocol.self) { resolver in
            presenter
        }
        
        filterCoordinator = NotificationsFilterCoordinator(
            dependenciesResolver: dependenciesResolver,
            navigationController: navigationController,
            delegate: self
        )
        
        self.dependenciesEngine.register(for: PLNotificationGetPushListUseCase.self) { resolver in
            return PLNotificationGetPushListUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationGetPushDetailsUseCase.self) { resolver in
            return PLNotificationGetPushDetailsUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationGetUnreadedPushCountUseCase.self) { resolver in
            return PLNotificationGetUnreadedPushCountUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationGetEnabledPushCategoriesByDeviceUseCase.self) { resolver in
            return PLNotificationGetEnabledPushCategoriesByDeviceUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationPostPushStatusUseCase.self) { resolver in
            return PLNotificationPostPushStatusUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationPostPushListPageSizeUseCase.self) { resolver in
            return PLNotificationPostPushListPageSizeUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationPostSetAllPushStatusUseCase.self) { resolver in
            return PLNotificationPostSetAllPushStatusUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: NotificationsInboxListViewController.self) { resolver in
            var presenter = resolver.resolve(for: NotificationsInboxListPresenterProtocol.self)
            let viewController = NotificationsInboxListViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        
    }
    
    func onFiltersSelected(_ selectedFilters: [EnabledPushCategorie],_ selectedStatuses: [NotificationStatus]) {
        delegate?.refreshDataWithFilters(selectedFilters, selectedStatuses)
    }
}
