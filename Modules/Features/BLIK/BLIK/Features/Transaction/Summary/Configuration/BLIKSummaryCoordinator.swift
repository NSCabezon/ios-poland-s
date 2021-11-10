import UI
import Models
import Commons
import Operative

protocol BLIKSummaryCoordinatorProtocol {
    func goToGlobalPosition()
    func goToMakeAnotherPayment()
    func goToAliasRegistration(with proposedAlias: Transaction.AliasProposal)
}

final class BLIKSummaryCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
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
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: BLIKSummaryViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension BLIKSummaryCoordinator: BLIKSummaryCoordinatorProtocol {
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToMakeAnotherPayment() {
        let blikHomeVC = navigationController?.viewControllers.reversed().first(where: { $0 is BLIKHomeViewController })
        if let blikHomeVC = blikHomeVC {
            self.navigationController?.popToViewController(blikHomeVC, animated: true)
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToAliasRegistration(with proposedAlias: Transaction.AliasProposal) {
        // TODO:- Present alias registration form
    }
}

/**
 #Register Scene depencencies.
*/

private extension BLIKSummaryCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: BLIKSummaryCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: BLIKSummaryPresenterProtocol.self) {[viewModel] resolver in
            return BLIKSummaryPresenter(dependenciesResolver: resolver, viewModel: viewModel)
        }

        self.dependenciesEngine.register(for: BLIKSummaryViewController.self) { resolver in
            let presenter = resolver.resolve(for: BLIKSummaryPresenterProtocol.self)
            let viewController = BLIKSummaryViewController(
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}
