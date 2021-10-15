//
//  DashboardPresenter.swift
//  mCommerce
//
//  Created by 186484 on 10/09/2021.
//

import UI
import Models
import Commons
import DomainCommon

protocol DashboardPresenterProtocol: MenuTextWrapperProtocol {
    var view: DashboardViewProtocol? { get set }

    func viewDidLoad()
    func backButtonSelected()
}

final class DashboardPresenter {
    weak var view: DashboardViewProtocol?
    let dependenciesResolver: DependenciesResolver
        
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
}

private extension DashboardPresenter {
    var coordinator: DashboardCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: DashboardCoordinatorProtocol.self)
    }
}

extension DashboardPresenter: DashboardPresenterProtocol {
    
    func viewDidLoad() {
        
    }
    
    func backButtonSelected() {
        coordinator.goBack()
    }
    
}
