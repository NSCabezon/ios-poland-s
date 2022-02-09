//
//  PLOneTransferHomeActionsCoordinator.swift
//  Santander
//
//  Created by Carlos Monfort Gómez on 24/12/21.
//

import Foundation
import UI
import CoreFoundationLib

class PLOneTransferHomeActionsCoordinator: BindableCoordinator {
    weak var navigationController: UINavigationController?
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var dataBinding: DataBinding = DataBindingObject()
    
    func start() {
        guard let type: String = dataBinding.get(),
              let actionType = PLSendMoneyActionTypeIdentifier(rawValue: type)
        else { return }
        switch actionType {
        case .blik:
            ToastCoordinator().start()
        case .anotherBank:
            ToastCoordinator().start()
        case .creditCard:
            ToastCoordinator().start()
        case .transferTax:
            ToastCoordinator().start()
        case .transferZus:
            ToastCoordinator().start()
        case .fxExchange:
            ToastCoordinator().start()
        case .scanPay:
            ToastCoordinator().start()
        case .topUpPhone:
            ToastCoordinator().start()
        }
    }
}
