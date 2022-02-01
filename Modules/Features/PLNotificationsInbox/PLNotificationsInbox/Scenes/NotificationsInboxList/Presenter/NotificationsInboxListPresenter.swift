//
//  NotificationsInboxListPresenter.swift
//  NotificationsInbox
//
//  Created by 186484 on 10/09/2021.
//

import UI
import CoreFoundationLib
import CoreFoundationLib

protocol NotificationsInboxListPresenterProtocol: MenuTextWrapperProtocol {
    var view: NotificationsInboxListViewProtocol? { get set }

    func viewDidLoad()
    func backButtonSelected()
}

final class NotificationsInboxListPresenter {
    weak var view: NotificationsInboxListViewProtocol?
    let dependenciesResolver: DependenciesResolver
        
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
}

private extension NotificationsInboxListPresenter {
    var coordinator: NotificationsInboxListCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: NotificationsInboxListCoordinatorProtocol.self)
    }
}

extension NotificationsInboxListPresenter: NotificationsInboxListPresenterProtocol {
    
    func viewDidLoad() {
        // TODO: In future user story
    }
    
    func backButtonSelected() {
        coordinator.goBack()
    }
    
}
