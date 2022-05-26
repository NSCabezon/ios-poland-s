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
import PhoneTopUp
import ZusTransfer
import ScanAndPay
import TaxTransfer

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
              let actionType = PLSendMoneyHomeActionTypeIdentifier(rawValue: type)
        else { return }
        switch actionType {
        case .blik:
            let coordinator = oldResolver.resolve(for: ContactsCoordinatorProtocol.self)
            coordinator.start()
        case .anotherBank:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .creditCard:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .transferTax:
            let coordinator = oldResolver.resolve(for: TaxTransferFormCoordinatorProtocol.self)
            coordinator.start()
        case .transferZus:
            let coordinator = oldResolver.resolve(for: ZusTransferModuleCoordinatorProtocol.self)
            coordinator.start()
        case .fxExchange:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .scanPay:
            let coordinator = oldResolver.resolve(for: ScanAndPayScannerCoordinatorProtocol.self)
            coordinator.start()
        case .topUpPhone:
            let coordinator = oldResolver.resolve(for: TopUpDataLoaderCoordinatorProtocol.self)
            coordinator.start()
        case .splitPayment:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        case .pendingSignatures:
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        }
    }
}
