import UI
import CoreFoundationLib

public protocol PLHelpCenterModuleCoordinatorDelegate: AnyObject {
    func didSelectMenu()
}

final public class PLHelpCenterModuleCoordinator: ModuleCoordinator {
    
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let helpCenterCoordinator: HelpCenterDashboardCoordinator
    
    private var delegate: PLHelpCenterModuleCoordinatorDelegate {
        return self.dependenciesEngine.resolve(for: PLHelpCenterModuleCoordinatorDelegate.self)
    }
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.helpCenterCoordinator = HelpCenterDashboardCoordinator(dependenciesResolver: dependenciesResolver, navigationController: navigationController)
        setupDependencies()
    }
    
    public func start() {
        helpCenterCoordinator.start()
    }
}

private extension PLHelpCenterModuleCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: PLHelpCenterModuleCoordinator.self) { _ in
            return self
        }
    }
}
