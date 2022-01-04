//
//  TaxTransferFormCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 01/12/2021.
//

import UI
import CoreFoundationLib
import Commons
import SANPLLibrary

public protocol TaxTransferFormCoordinatorProtocol: ModuleCoordinator {}

public final class TaxTransferFormCoordinator: ModuleCoordinator {
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
        let controller = UIViewController() // TODO:- Implement actual controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension TaxTransferFormCoordinator: TaxTransferFormCoordinatorProtocol {}
