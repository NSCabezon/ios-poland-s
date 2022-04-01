import UI
import CoreFoundationLib
import SANPLLibrary
import PLCommons

public protocol SplitPaymentModuleCoordinatorProtocol: ModuleCoordinator {
    func close()
    func showSplitPaymentForm(with accounts: [AccountForDebit], selectedAccountNumber: String)
    func showSplitPaymentAccountSelector(with accounts: [AccountForDebit])
}
    
public final class SplitPaymentModuleCoordinator: SplitPaymentModuleCoordinatorProtocol {
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setUpDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: SplitPaymentModuleViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    public func close() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    public func showSplitPaymentForm(with accounts: [AccountForDebit], selectedAccountNumber: String) {
        let coordinator = SplitPaymentFormCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber
        )
        coordinator.start()
        removeModuleControllerFromStack()
    }
    
    public func showSplitPaymentAccountSelector(with accounts: [AccountForDebit]) {
        let coordinator = SplitPaymentAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: "",
            sourceView: .sendMoney
        )
        coordinator.start()
        removeModuleControllerFromStack()
    }
}

extension SplitPaymentModuleCoordinator {
    private func setUpDependencies() {
        dependenciesEngine.register(for: SplitPaymentModuleCoordinatorProtocol.self) { _ in
            self
        }
        dependenciesEngine.register(for: SplitPaymentModulePresenterProtocol.self) { resolver in
            SplitPaymentModulePresenter(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: SplitPaymentModuleViewController.self) { resolver in
            let presenter = resolver.resolve(for: SplitPaymentModulePresenterProtocol.self)
            let viewController = SplitPaymentModuleViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    private func removeModuleControllerFromStack() {
        let firstIndex = navigationController?.viewControllers.firstIndex {
            $0 is SplitPaymentModuleViewController
        }
        guard let count = navigationController?.viewControllers.count,
              let index = firstIndex,
              count > index else { return }
        
        navigationController?.viewControllers.remove(at: index)
    }
}
