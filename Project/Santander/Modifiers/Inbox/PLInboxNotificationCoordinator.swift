//
//  PLInboxNotificationCoordinator.swift
//  Santander
//
//  Created by 185998 on 29/12/2021.
//

import Inbox
import PLNotificationsInbox
import CoreFoundationLib

public class PLInboxNotificationCoordinator: InboxNotificationCoordinatorDelegate {

    private let dependenciesResolver: DependenciesResolver & DependenciesInjector

    init(dependenciesResolver: DependenciesResolver & DependenciesInjector) {
        self.dependenciesResolver = dependenciesResolver
    }

    public func gotoInboxNotification(showHeader: Bool, navigationController: UINavigationController) {
        let coordinator = PLNotificationsInboxModuleCoordinator(
            dependenciesResolver: dependenciesResolver,
            navigationController: navigationController
        )
        coordinator.start()
    }
}
