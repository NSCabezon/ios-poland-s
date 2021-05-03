import Commons

public class PLLoginModuleCoordinator: ModuleSectionedCoordinator {
    public var navigationController: UINavigationController?
    let coordinator: PLLoginMainModuleCoordinator

    public enum PLLoginSection: CaseIterable {
        case main
    }
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.coordinator = PLLoginMainModuleCoordinator(dependenciesResolver: dependenciesResolver, navigationController: navigationController)
    }
    
    public func start(_ section: PLLoginSection) {
        switch section {
        case .main:
             return self.coordinator.start()
        }
    }
}
