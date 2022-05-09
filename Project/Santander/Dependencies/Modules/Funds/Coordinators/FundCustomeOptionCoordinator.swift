//
//  FundCustomeOptionCoordinator.swift
//  Santander
//

import UI
import Funds
import CoreFoundationLib
import Foundation
import CoreDomain

final class FundCustomeOptionCoordinator: BindableCoordinator {
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var dataBinding: DataBinding = DataBindingObject()
    
    func start() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}
