import UI
import CoreFoundationLib

protocol LoanScheduleDetailsCoordinatorProtocol: ModuleCoordinator {
    func goBack()
}

final class LoanScheduleDetailsCoordinator: LoanScheduleDetailsCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    private let loanScheduleItem: LoanSchedule.ItemEntity
    
    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         loanScheduleItem: LoanSchedule.ItemEntity
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.loanScheduleItem = loanScheduleItem
        self.setupDependencies()
    }
    
    public func start() {
        let presenter = LoanScheduleDetailsPresenter(
            dependenciesResolver: dependenciesEngine,
            loanScheduleItem: loanScheduleItem
        )
        let controller = LoanScheduleDetailsViewController(presenter: presenter)
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
 */

private extension LoanScheduleDetailsCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: LoanScheduleDetailsCoordinatorProtocol.self) { _ in
            self
        }
        
        dependenciesEngine.register(for: LoanScheduleDetailsViewModelMapping.self) { resolver in
            return LoanScheduleDetailsViewModelMapper()
        }
        
        dependenciesEngine.register(for: LoanScheduleDetailsViewController.self) { resolver in
            var presenter = resolver.resolve(for: LoanScheduleDetailsPresenterProtocol.self)
            let viewController = LoanScheduleDetailsViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}
