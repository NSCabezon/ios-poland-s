//
//  mCommerceModuleCoordinator.swift
//  mCommerce
//

import UI
import Commons

final public class mCommerceModuleCoordinator: ModuleCoordinator {
    
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let dashboardCoordinator: DashboardCoordinator
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.dashboardCoordinator = DashboardCoordinator(dependenciesResolver: dependenciesResolver, navigationController: navigationController)
        setupDependencies()
    }
    
    public func start() {
        dashboardCoordinator.start()
    }

}

private extension mCommerceModuleCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: mCommerceModuleCoordinator.self) { _ in
            return self
        }
    }
}
