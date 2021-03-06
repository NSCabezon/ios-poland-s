//
//  PLPublicMenuAuthorizationCoordinator.swift
//  Authorization
//
//  Created by 186484 on 04/05/2022.
//

import UI
import CoreFoundationLib

public final class PLPublicMenuAuthorizationCoordinator: BindableCoordinator {
    private let dependenciesResolver: DependenciesResolver
    public weak var navigationController: UINavigationController?
    public var onFinish: (() -> Void)?
    public var childCoordinators: [Coordinator] = []
    public var dataBinding: DataBinding = DataBindingObject()
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private lazy var authorizationCoordinator: AuthorizationModuleCoordinator = {
        let authorizationCoordinator = dependenciesResolver.resolve(for: AuthorizationModuleCoordinator.self)
        authorizationCoordinator.onAuthorizationSuccess = onFinish
        return authorizationCoordinator
    }()
    
    public func start() {
        authorizationCoordinator.start()
    }
}
