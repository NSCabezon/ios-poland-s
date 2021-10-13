//
//  SendMoneyCoordinator.swift
//  Santander
//
//  Created by José María Jiménez Pérez on 20/9/21.
//

import UIKit
import Commons
import UI
import TransferOperatives
import Operative

protocol SendMoneyCoordinatorProtocol: ModuleCoordinator { }

final class SendMoneyCoordinator {
    weak var navigationController: UINavigationController?
    let dependenciesResolver: DependenciesResolver
    private let drawer: BaseMenuController
    
    init (dependenciesResolver: DependenciesResolver, drawer: BaseMenuController) {
        self.drawer = drawer
        self.dependenciesResolver = dependenciesResolver
    }
    
    func start() {
        self.goToSendMoney(handler: self)
    }
}

extension SendMoneyCoordinator: SendMoneyCoordinatorProtocol { }

extension SendMoneyCoordinator: OperativeLauncherHandler {
    var operativeNavigationController: UINavigationController? {
        return self.drawer.currentRootViewController as? UINavigationController
    }
    
    func showOperativeLoading(completion: @escaping () -> Void) {
        self.showLoading(completion: completion)
    }
    
    func hideOperativeLoading(completion: @escaping () -> Void) {
        self.dismissLoading(completion: completion)
    }
    
    func showOperativeAlertError(keyTitle: String?, keyDesc: String?, completion: (() -> Void)?) {
        completion?()
    }
}

extension SendMoneyCoordinator: SendMoneyOperativeLauncher { }
extension SendMoneyCoordinator: LoadingViewPresentationCapable {
    var associatedLoadingView: UIViewController {
        return self.operativeNavigationController?.topViewController ?? UIViewController()
    }
}
