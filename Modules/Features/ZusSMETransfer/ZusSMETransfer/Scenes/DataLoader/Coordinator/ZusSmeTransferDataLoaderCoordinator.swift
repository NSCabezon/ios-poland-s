import UI
import CoreFoundationLib
import SANPLLibrary
import PLCommons

public protocol ZusSmeTransferDataLoaderCoordinatorProtocol: ModuleCoordinator {
    func close()
    func showZusTransferForm(with accounts: [AccountForDebit], selectedAccountNumber: String)
    func showZusAccountSelector(with accounts: [AccountForDebit])
}

public final class ZusSmeTransferDataLoaderCoordinator: ZusSmeTransferDataLoaderCoordinatorProtocol {
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
        let controller = self.dependenciesEngine.resolve(for: ZusSmeTransferDataLoaderViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    public func close() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    public func showZusTransferForm(with accounts: [AccountForDebit], selectedAccountNumber: String) {
        let coordinator = ZusSmeTransferFormCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber
        )
        coordinator.start()
        removeModuleControllerFromStack()
    }
    
    public func showZusAccountSelector(with accounts: [AccountForDebit]) {
        let coordinator = ZusSmeAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            sourceView: .sendMoney
        )
        coordinator.start()
        removeModuleControllerFromStack()
    }
}

extension ZusSmeTransferDataLoaderCoordinator {
    private func setUpDependencies() {
        dependenciesEngine.register(for: ZusSmeTransferDataLoaderCoordinatorProtocol.self) { _ in
            self
        }
        dependenciesEngine.register(for: ZusSmeTransferDataLoaderPresenterProtocol.self) { resolver in
            ZusSmeTransferDataLoaderPresenter(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: ZusSmeTransferDataLoaderViewController.self) { resolver in
            let presenter = resolver.resolve(for: ZusSmeTransferDataLoaderPresenterProtocol.self)
            let viewController = ZusSmeTransferDataLoaderViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    func removeModuleControllerFromStack() {
        let firstIndex = navigationController?.viewControllers.firstIndex {
            $0 is ZusSmeTransferDataLoaderViewController
        }
        guard let count = navigationController?.viewControllers.count,
              let index = firstIndex,
              count > index else { return }
        
        navigationController?.viewControllers.remove(at: index)
    }
}
