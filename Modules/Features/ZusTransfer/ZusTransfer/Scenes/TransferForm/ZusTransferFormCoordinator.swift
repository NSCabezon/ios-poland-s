//
//  ZusTransferFormCoordinator.swift
//  ZusTransfer
//
//  Created by 187830 on 14/12/2021.
//

import UI
import Models
import Commons
import SANPLLibrary

public protocol ZusTransferFormCoordinatorProtocol: ModuleCoordinator {}

public final class ZusTransferFormCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
    }
    
    public func start() {
        // TODO:- Implement Transfer form controller
        let controller = UIViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ZusTransferFormCoordinator: ZusTransferFormCoordinatorProtocol {}

