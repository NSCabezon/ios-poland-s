//
//  PLSavingsHomeTransactionsActionsCoordinator.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 21/4/22.
//

import Foundation
import SavingProducts
import UI
import CoreDomain
import CoreFoundationLib

final class PLSavingsHomeTransactionsActionsCoordinator: SavingsHomeTransactionsActionsCoordinator {
    var dataBinding: DataBinding = DataBindingObject()
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let type: SavingProductsTransactionsButtonsType = self.dataBinding.get() else { return }
        switch type {
        case .downloadPDF:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        case .filter:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}
