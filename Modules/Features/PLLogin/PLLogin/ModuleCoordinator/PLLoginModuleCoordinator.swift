import UI
import Commons
import LoginCommon

public class PLLoginModuleCoordinator: ModuleSectionedCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let unrememberdLoginIdCoordinator: PLUnrememberedLoginIdCoordinator
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.unrememberdLoginIdCoordinator = PLUnrememberedLoginIdCoordinator(dependenciesResolver: dependenciesEngine, navigationController: navigationController)
    }
}

extension PLLoginModuleCoordinator: LoginModuleCoordinatorProtocol {
    public func start(_ section: LoginSection) {
        switch section {
        case .unrememberedLogin:
            return self.unrememberdLoginIdCoordinator.start()
        case .loginRemembered:
            break
        case .quickBalance:
            break
        }
    }
}
