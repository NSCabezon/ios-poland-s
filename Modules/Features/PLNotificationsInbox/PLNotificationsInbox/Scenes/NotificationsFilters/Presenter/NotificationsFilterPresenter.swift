//
//  NotificationsFilterPresenter.swift
//  PLNotificationsInbox
//
//  Created by 188418 on 30/12/2021.
//

import UIKit
import PLNotifications
import SANPLLibrary
import CoreFoundationLib

protocol NotificationsFilterPresenterProtocol: MenuTextWrapperProtocol {
    var view: NotificationsFilterViewProtocol? { get set }
    func viewDidLoad()
    func didSelectClose()
    func setFilters(_ filters: [EnabledPushCategorie],_ statuses: [NotificationStatus])
    func getEnabledPushCategories(completion: @escaping (PLEnabledPushCategoriesListEntity?) -> Void)
}

final class NotificationsFilterPresenter {
    var actionType: CustomPushLaunchActionTypeInfo?
    weak var view: NotificationsFilterViewProtocol?
    let dependenciesResolver: DependenciesResolver
    
    private lazy var notificationsUseCaseManager: PLNotificationsUseCaseManagerProtocol? = {
        return self.dependenciesResolver.resolve(forOptionalType: PLNotificationsUseCaseManagerProtocol.self)
    }()
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension NotificationsFilterPresenter: NotificationsFilterPresenterProtocol {
    func setType(_ actionType: CustomPushLaunchActionTypeInfo) {
        self.actionType = actionType
    }
    
    func setFilters(_ filters: [EnabledPushCategorie],_ statuses: [NotificationStatus]) {
        coordinator.setFilters(filters, statuses)
    }
    
    func viewDidLoad() {
        getEnabledPushCategories { categories in
            guard
                let response = categories,
                response.enabledCategories.isNotEmpty
            else { return }
            self.view?.addFilters(response.enabledCategories, NotificationStatus.getFilerList())
        }
    }
    
    func didSelectClose() {
        coordinator.pop()
    }
    
    func getEnabledPushCategories(completion: @escaping (PLEnabledPushCategoriesListEntity?) -> Void) {
        notificationsUseCaseManager?.getEnabledPushCategories(completion: completion)
    }

}

private extension NotificationsFilterPresenter {
    var coordinator: NotificationsFilterCoordinatorProtocol {
        dependenciesResolver.resolve(for: NotificationsFilterCoordinatorProtocol.self)
    }
}
