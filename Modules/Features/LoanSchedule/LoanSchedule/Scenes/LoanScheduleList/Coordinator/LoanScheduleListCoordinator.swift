import UI
import CoreFoundationLib
import Commons

/**
    #Add method that must be handle by the PLLoanScheduleCoordinator like
    navigation between the module scene and so on.
*/
protocol LoanScheduleListCoordinatorProtocol: ModuleCoordinator {
    func goToDetails(with item: LoanSchedule.ItemEntity)
    func goBack()
}

final class LoanScheduleListCoordinator: LoanScheduleListCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        fatalError("This coordinator need to be started with LoanScheduleIdentity")
    }
    
    public func start(with loanScheduleIdentity: LoanScheduleIdentity) {
        var presenter = dependenciesEngine.resolve(for: LoanScheduleListPresenterProtocol.self)
        presenter.loanScheduleIdentity = loanScheduleIdentity
        
        let controller = self.dependenciesEngine.resolve(for: LoanScheduleListViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func goToDetails(with item: LoanSchedule.ItemEntity) {
        let detailsCoordinator = LoanScheduleDetailsCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            loanScheduleItem: item
        )
        detailsCoordinator.start()
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension LoanScheduleListCoordinator {
    func setupDependencies() {
        let presenter = LoanScheduleListPresenter(dependenciesResolver: dependenciesEngine)
        
        dependenciesEngine.register(for: LoanScheduleListCoordinatorProtocol.self) { _ in
            self
        }

        dependenciesEngine.register(for: LoanScheduleListPresenterProtocol.self) { resolver in
            presenter
        }

        dependenciesEngine.register(for: LoanScheduleListViewController.self) { resolver in
            var presenter = resolver.resolve(for: LoanScheduleListPresenterProtocol.self)
            let viewController = LoanScheduleListViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }

        dependenciesEngine.register(for: GetLoanScheduleUseCaseProtocol.self) { resolver in
            GetLoanScheduleUseCase(dependenciesResolver: resolver)
        }
    }
}
