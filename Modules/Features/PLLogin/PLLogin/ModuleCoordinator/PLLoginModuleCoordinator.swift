import UI
import Commons
import LoginCommon

public class PLLoginModuleCoordinator: ModuleSectionedCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let unrememberdLoginIdCoordinator: PLUnrememberedLoginIdCoordinator
    //REMOVE THIS BEFORE MERGING
    private let unrememberedLoginMaskedPawdCoordinator: PLUnrememberedLoginMaskedPwdCoordinator
    private let unrememberedLoginNormalPawdCoordinator: PLUnrememberedLoginNormalPwdCoordinator
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.unrememberdLoginIdCoordinator = PLUnrememberedLoginIdCoordinator(dependenciesResolver: dependenciesEngine, navigationController: navigationController)
        //REMOVE THIS BEFORE MERGING
        self.unrememberedLoginMaskedPawdCoordinator = PLUnrememberedLoginMaskedPwdCoordinator(dependenciesResolver: dependenciesResolver, navigationController: navigationController)
        self.unrememberedLoginNormalPawdCoordinator = PLUnrememberedLoginNormalPwdCoordinator(dependenciesResolver: dependenciesResolver, navigationController: navigationController)
    }
}

extension PLLoginModuleCoordinator: LoginModuleCoordinatorProtocol {
    public func start(_ section: LoginSection) {
        switch section {
        case .unrememberedLogin:
            return self.unrememberdLoginIdCoordinator.start()
        //REMOVE THIS BEFORE MERGING
//            return unrememberedLoginMaskedPawdCoordinator.start()
//            return unrememberedLoginNormalPawdCoordinator.start()
        case .loginRemembered:
            break
        case .quickBalance:
            break
        }
    }
}
