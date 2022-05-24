import UI
import CoreFoundationLib
import PLUI

protocol ZusTransferSummaryCoordinatorProtocol {
    func goToMakeAnotherPayment()
    func backToTransfers()
}

final class ZusTransferSummaryCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let summary: ZusTransferSummary

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         summary: ZusTransferSummary) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.summary = summary
        self.setupDependencies()
    }
    
    func start() {
        let presenter = ZusTransferSummaryPresenter(dependenciesResolver: dependenciesEngine, summary: summary)
        let controller = ZusTransferSummaryViewController(presenter: presenter)
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ZusTransferSummaryCoordinator: ZusTransferSummaryCoordinatorProtocol {
    func goToMakeAnotherPayment() {
        if let zusTransferFormVC = navigationController?.viewControllers.reversed().first(where: { $0 is ZusTransferFormViewProtocol }) {
            navigationController?.popToViewController(zusTransferFormVC, animated: true)
            (zusTransferFormVC as? ZusTransferFormViewProtocol)?.resetForm()
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    func backToTransfers() {
        let accountSelectorViewControllerIndex = navigationController?.viewControllers.firstIndex {
            $0 is AccountSelectorViewController
        }
        guard let accountSelectorViewControllerIndex = accountSelectorViewControllerIndex,
              let parentController = navigationController?.viewControllers[safe: accountSelectorViewControllerIndex - 1] else {
            let zusTransferFormViewControllerIndex = navigationController?.viewControllers.firstIndex {
                $0 is ZusTransferFormViewController
            }
            if let zusTransferFormViewControllerIndex = zusTransferFormViewControllerIndex,
               let parentController = navigationController?.viewControllers[safe: zusTransferFormViewControllerIndex - 1] {
                navigationController?.popToViewController(parentController, animated: true)
                return
            }
            navigationController?.popViewController(animated: true)
            return
            
        }
        navigationController?.popToViewController(parentController, animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension ZusTransferSummaryCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: ZusTransferSummaryCoordinatorProtocol.self) { _ in
            return self
        }
    }
}
