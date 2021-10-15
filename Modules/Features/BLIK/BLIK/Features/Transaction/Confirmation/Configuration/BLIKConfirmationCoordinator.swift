import UI
import Models
import Commons

/**
    #Add method that must be handle by the BLIKConfirmationCoordinator like 
    navigation between the module scene and so on.
*/
protocol BLIKConfirmationCoordinatorProtocol {
    func cancelTransfer(type: CancelType)
    func goToSummary()
    func goToGlobalPosition()
}

final class BLIKConfirmationCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let viewModel: BLIKTransactionViewModel
    
    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         viewModel: BLIKTransactionViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: BLIKConfirmationViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension BLIKConfirmationCoordinator: BLIKConfirmationCoordinatorProtocol {
    func cancelTransfer(type: CancelType) {
        let coordinator = CancelTransactionCoordinator(dependenciesResolver: dependenciesEngine,
                                                       navigationController: navigationController,
                                                       cancelType: type)
        coordinator.start()
    }
    
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToSummary() {
        let coordinator = BLIKSummaryCoordinator(dependenciesResolver: dependenciesEngine,
                                                 navigationController: navigationController,
                                                 viewModel: viewModel)
        
        coordinator.start()
    }
}

/**
 #Register Scene depencencies.
*/

private extension BLIKConfirmationCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: BLIKConfirmationCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: BLIKConfirmationPresenterProtocol.self) {[weak self] resolver in
            return BLIKConfirmationPresenter(dependenciesResolver: resolver, viewModel: self?.viewModel)
        }
         
        self.dependenciesEngine.register(for: BLIKConfirmationViewController.self) { resolver in
            var presenter = resolver.resolve(for: BLIKConfirmationPresenterProtocol.self)
            let viewController = BLIKConfirmationViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        
        self.dependenciesEngine.register(for: CancelBLIKTransactionProtocol.self) { resolver in
            return CancelBLIKTransactionUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: AcceptBLIKTransactionProtocol.self) { resolver in
            return AcceptBLIKTransactionUseCase(dependenciesResolver: resolver)
        }
    }
}
