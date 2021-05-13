import UI
import Commons
import LoginCommon

public class PLLoginModuleCoordinator: ModuleSectionedCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let unrememberdLoginCoordinator: PLUnrememberedLoginCoordinator
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.unrememberdLoginCoordinator = PLUnrememberedLoginCoordinator(dependenciesEngine: dependenciesEngine, navigationController: navigationController)
    }
}

extension PLLoginModuleCoordinator: LoginModuleCoordinatorProtocol {
    public func start(_ section: LoginSection) {
        switch section {
        case .unrememberedLogin:
            return self.unrememberdLoginCoordinator.start()
        case .loginRemembered:
            break
        case .quickBalance:
            break
        }
    }
}
