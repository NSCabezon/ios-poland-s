//
//  PublicMenuCustomActionCoordinator.swift
//  Santander
//
//  Created by Juan Jose Acosta González on 26/1/22.
//

import OpenCombine
import UI
import CoreFoundationLib
import Menu
import UIKit
import PLHelpCenter
import Authorization

public final class DefaultPublicMenuCustomActionCoordinator {
    weak public var navigationController: UINavigationController?
    private let dependenciesResolver: DependenciesResolver
    public var childCoordinators: [Coordinator] = []
    lazy public var dataBinding: DataBinding = dependencies.resolve()
    public var onFinish: (() -> Void)?
    
    private lazy var dependencies: Dependency = {
        return Dependency()
    }()
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.dependenciesResolver = dependenciesResolver
        self.navigationController = navigationController
    }
}

extension DefaultPublicMenuCustomActionCoordinator: BindableCoordinator {

    public func resolve() -> DataBinding {
        self.dataBinding
    }
    
    public func resolve() -> UINavigationController {
        return self.navigationController ?? UINavigationController()
    }
    
    public func start() {
        var coordinator: Coordinator
        guard let action: String = dataBinding.get(),
                let plAction = PLCustomActions(rawValue: action) else { return }
        switch plAction {
        case .otherUser:
            coordinator = ToastCoordinator("generic_alert_notAvailableOperation")
        case .information:
            coordinator = ToastCoordinator("generic_alert_notAvailableOperation")
        case .service:
            coordinator = ToastCoordinator("generic_alert_notAvailableOperation")
        case .offer:
            coordinator = ToastCoordinator("generic_alert_notAvailableOperation")
        case .mobileAuthorization:
            coordinator = PLPublicMenuAuthorizationCoordinator(dependenciesResolver: dependenciesResolver,
                                                               navigationController: navigationController)
        case .contactMenu:
            coordinator = PLPublicMenuHelpCenterCoordinator(dependenciesResolver: dependenciesResolver,
                                                            navigationController: navigationController)
        }
        coordinator.start()
        append(child: coordinator)
    }
}

private extension DefaultPublicMenuCustomActionCoordinator {
    struct Dependency: PublicMenuCustomActionDependenciesResolver {
        let dataBinding = DataBindingObject()
        
        func resolve() -> DataBinding {
            return dataBinding
        }
    }
}
