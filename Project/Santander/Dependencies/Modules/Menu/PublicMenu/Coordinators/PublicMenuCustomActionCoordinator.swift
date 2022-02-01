//
//  PublicMenuCustomActionCoordinator.swift
//  Santander
//
//  Created by Juan Jose Acosta González on 26/1/22.
//

import OpenCombine
import UI
import Commons
import Menu
import UIKit

public final class DefaultPublicMenuCustomActionCoordinator {
    weak public var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    private let externalDependencies: PublicMenuCustomActionExternalDependenciesResolver
    lazy public var dataBinding: DataBinding = dependencies.resolve()
    public var onFinish: (() -> Void)?
    
    private lazy var dependencies: Dependency = {
        return Dependency(external: externalDependencies)
    }()
    
    public init(dependencies: PublicMenuCustomActionExternalDependenciesResolver, navigationController: UINavigationController?) {
        self.externalDependencies = dependencies
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
            coordinator = ToastCoordinator("generic_alert_notAvailableOperation")
        }
        coordinator.start()
        append(child: coordinator)
    }
}

private extension DefaultPublicMenuCustomActionCoordinator {
    struct Dependency: PublicMenuCustomActionDependenciesResolver {
        var external: PublicMenuCustomActionExternalDependenciesResolver
        let dataBinding = DataBindingObject()
        
        var externalDependencies: PublicMenuCustomActionExternalDependenciesResolver {
            return external
        }
        
        func resolve() -> DataBinding {
            return dataBinding
        }
    }
}
