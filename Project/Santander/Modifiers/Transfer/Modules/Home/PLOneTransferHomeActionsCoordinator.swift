//
//  PLOneTransferHomeActionsCoordinator.swift
//  Santander
//
//  Created by Carlos Monfort Gómez on 24/12/21.
//

import CoreFoundationLib
import UI
import BLIK
import Transfer

class PLOneTransferHomeActionsCoordinator: BindableCoordinator {
    weak var navigationController: UINavigationController?
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var dataBinding: DataBinding = DataBindingObject()
    let oldResolver: DependenciesResolver
    
    init(transferExternalResolver: TransferExternalDependenciesResolver) {
        self.oldResolver = transferExternalResolver.resolve()
    }
    
    func start() {
        guard let type: String = dataBinding.get(),
              let actionType = PLSendMoneyActionTypeIdentifier(rawValue: type)
        else { return }
        switch actionType {
        case .blik:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .anotherBank:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .creditCard:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .transferTax:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .transferZus:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .fxExchange:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .scanPay:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .topUpPhone:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        }
    }
}
