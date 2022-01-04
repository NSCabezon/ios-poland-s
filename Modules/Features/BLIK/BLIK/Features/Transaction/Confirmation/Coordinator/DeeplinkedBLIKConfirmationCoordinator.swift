//
//  DeeplinkedBLIKConfirmationCoordinator.swift
//  BLIK
//
//  Created by 185167 on 19/11/2021.
//

import UI
import CoreFoundationLib
import Commons

public final class DeeplinkedBLIKConfirmationCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    public init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
    }
    
    public func start() {
        let coordinator = BLIKConfirmationCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            viewModelSource: .needsToBeFetched
        )
        coordinator.start()
    }
}
