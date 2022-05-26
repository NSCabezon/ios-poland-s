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
import Cards
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
    
    private let dependenciesEngine: DependenciesDefault

    private let cardExternalDependencies: CardExternalDependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?, cardExternalDependencies: CardExternalDependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.navigationController = navigationController
        self.cardExternalDependencies = cardExternalDependencies
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
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
        case .cancelCard:
            coordinator = PLPublicMenuAuthorizationCoordinator(dependenciesResolver: dependenciesResolver,
                                                               navigationController: navigationController)
            coordinator.onFinish = { [weak self] in
                guard let self = self else { return }
                self.dependenciesEngine.register(for: CardsHomeConfiguration.self) { _ in
                    return CardsHomeConfiguration(selectedCard: nil)
                }
                let cardCoordinator = CardsModuleCoordinator(dependenciesResolver: self.dependenciesEngine, navigationController: self.resolve(), externalDependencies: self.cardExternalDependencies)
                self.navigationController?.popViewController(animated: true) {
                    cardCoordinator.start(.home)
                }
            }
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
