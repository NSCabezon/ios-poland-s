//
//  AuthorizationCoordinator.swift
//  Account
//
//  Created by Patryk Grabowski on 14/03/2022.
//

import CoreFoundationLib
import UI

public protocol AuthorizationCoordinatorProtocol: ModuleCoordinator {
    func back()
}

public final class AuthorizationCoordinator: AuthorizationCoordinatorProtocol {
    public weak var navigationController: UINavigationController?
    
    private let dependenciesEngine: DependenciesDefault
    private lazy var authorizationPresenter = dependenciesEngine.resolve(for: AuthorizationPresenterProtocol.self)

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        setUpDependencies()
    }
    
    public func start() {
        let controller = AuthorizationViewController(presenter: authorizationPresenter)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    public func back() {
        navigationController?.popViewController(animated: true)
    }
}

private extension AuthorizationCoordinator {
    func setUpDependencies() {        
        dependenciesEngine.register(for: AuthorizationCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: AuthorizationPresenterProtocol.self) { resolver in
            return AuthorizationPresenter(dependenciesResolver: resolver)
        }
    }
}
