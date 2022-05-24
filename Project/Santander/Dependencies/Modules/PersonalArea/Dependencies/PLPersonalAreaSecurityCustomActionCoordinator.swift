//
//  PLPersonalAreaSecurityCustomActionCoordinator.swift
//  Santander
//
//  Created by 185860 on 20/05/2022.
//

import UI
import CoreFoundationLib
import PLQuickBalance

final class PLPersonalAreaSecurityCustomActionCoordinator: BindableCoordinator {
    var dataBinding: DataBinding = DataBindingObject()
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    let quickBalancebCordinator: PLQuickBalanceCoordinatorProtocol
    
    func start() {
        quickBalancebCordinator.showEnableQuickBalanceViewFromSettings()
    }
    
    init(quickBalancebCordinator: PLQuickBalanceCoordinatorProtocol, navigationController: UINavigationController?) {
        self.quickBalancebCordinator = quickBalancebCordinator
        self.navigationController = navigationController
    }
    
}
