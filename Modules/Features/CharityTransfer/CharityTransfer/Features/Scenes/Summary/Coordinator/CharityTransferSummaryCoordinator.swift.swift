import UI
import CoreFoundationLib
import CoreFoundationLib

protocol CharityTransferSummaryCoordinatorProtocol {
    func goToMakeAnotherPayment()
    func goToGlobalPosition()
}

final class CharityTransferSummaryCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let summary: CharityTransferSummary

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         summary: CharityTransferSummary) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.summary = summary
        self.setupDependencies()
    }
    
    func start() {
        let presenter = CharityTransferSummaryPresenter(dependenciesResolver: dependenciesEngine, summary: summary)
        let controller = CharityTransferSummaryViewController(presenter: presenter)
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension CharityTransferSummaryCoordinator: CharityTransferSummaryCoordinatorProtocol {
    func goToMakeAnotherPayment() {
        let charityTransferFormVC = navigationController?.viewControllers.reversed().first(where: { $0 is CharityTransferFormViewController })
        if let charityTransferFormVC = charityTransferFormVC {
            navigationController?.popToViewController(charityTransferFormVC, animated: true)
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension CharityTransferSummaryCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: CharityTransferSummaryCoordinatorProtocol.self) { _ in
            return self
        }
    }
}
