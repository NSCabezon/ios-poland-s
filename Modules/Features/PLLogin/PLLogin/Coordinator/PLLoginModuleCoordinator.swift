import UI
import Commons
import LoginCommon

public class PLLoginModuleCoordinator: ModuleSectionedCoordinator {
    public weak var navigationController: UINavigationController?
    private let unrememberdLoginCoordinator: UnrememberedLoginCoordinator
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

extension PLLoginModuleCoordinator: LoginModuleCoordinatorProtocol {
    public func start(_ section: LoginSection) {
        switch section {
        case .unrememberedLogin:
            break
        case .loginRemembered:
            break
        case .quickBalance:
            break
        }
    }
}
