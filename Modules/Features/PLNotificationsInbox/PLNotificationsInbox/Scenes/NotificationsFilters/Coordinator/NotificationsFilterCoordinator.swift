//
//  NotificationsFilterCoordinator.swift
//  Account
//
//  Created by 188418 on 30/12/2021.
//

import UIKit
import UI
import PLNotifications
import SANPLLibrary
import CoreFoundationLib

public protocol NotificationsFilterCoordinatorResultDelegate: AnyObject {
    func onFiltersSelected(_ selectedFilters: [EnabledPushCategorie],_ selectedStatuses: [NotificationStatus])
}

protocol NotificationsFilterCoordinatorProtocol {
    func pop()
    func setFilters(_ selectedFilters: [EnabledPushCategorie],_ selectedStatuses: [NotificationStatus])
}

public class NotificationsFilterCoordinator: ModuleCoordinator {
    var selectedFilters: [EnabledPushCategorie]?
    var selectedStatuses: [NotificationStatus]?
    fileprivate var actionType: CustomPushLaunchActionTypeInfo?
    fileprivate var delegate: NotificationsFilterCoordinatorResultDelegate?
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?, delegate: NotificationsFilterCoordinatorResultDelegate?) {
        self.navigationController = navigationController
        self.delegate = delegate
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: NotificationsFilterViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension NotificationsFilterCoordinator: NotificationsFilterCoordinatorProtocol {
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setFilters(_ selectedFilters: [EnabledPushCategorie],_ selectedStatuses: [NotificationStatus]) {
        self.delegate?.onFiltersSelected(selectedFilters, selectedStatuses)
        pop()
    }
    
    func setupDependencies() {
        self.dependenciesEngine.register(for: NotificationsFilterViewController.self) { resolver in
            var presenter = resolver.resolve(for: NotificationsFilterPresenterProtocol.self)
            let viewController = NotificationsFilterViewController(presenter: presenter, self.selectedFilters ?? [], self.selectedStatuses ?? [])
            presenter.view = viewController
            return viewController
        }
        
        self.dependenciesEngine.register(for: NotificationsFilterCoordinatorProtocol.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: NotificationsFilterPresenterProtocol.self) { resolver in
            return NotificationsFilterPresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationGetEnabledPushCategoriesByDeviceUseCase.self) { resolver in
            return PLNotificationGetEnabledPushCategoriesByDeviceUseCase(dependenciesResolver: resolver)
        }
    }
    
    func showVC(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
