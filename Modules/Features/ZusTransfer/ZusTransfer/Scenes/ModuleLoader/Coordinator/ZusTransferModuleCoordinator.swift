import UI
import CoreFoundationLib
import SANPLLibrary
import PLCommons

public protocol ZusTransferModuleCoordinatorProtocol: ModuleCoordinator {
    func close()
    func showZusTransferForm(with accounts: [AccountForDebit], selectedAccountNumber: String)
    func showZusAccountSelector(with accounts: [AccountForDebit])
}

public final class ZusTransferModuleCoordinator: ZusTransferModuleCoordinatorProtocol {
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let validationMask: String
    
    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        validationMask: String?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.validationMask = validationMask ?? ""
        self.setUpDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: ZusTransferModuleViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    public func close() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    public func showZusTransferForm(with accounts: [AccountForDebit], selectedAccountNumber: String) {
        let coordinator = ZusTransferFormCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber,
            validationMask: validationMask
        )
        coordinator.start()
        removeModuleControllerFromStack()
    }
    
    public func showZusAccountSelector(with accounts: [AccountForDebit]) {
        let coordinator = ZusAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: "",
            validationMask: validationMask,
            sourceView: .sendMoney
        )
        coordinator.start()
        removeModuleControllerFromStack()
    }
}

extension ZusTransferModuleCoordinator {
    private func setUpDependencies() {
        dependenciesEngine.register(for: ZusTransferModuleCoordinatorProtocol.self) { _ in
            self
        }
        dependenciesEngine.register(for: ZusTransferModulePresenterProtocol.self) { resolver in
            ZusTransferModulePresenter(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: ZusTransferModuleViewController.self) { resolver in
            let presenter = resolver.resolve(for: ZusTransferModulePresenterProtocol.self)
            let viewController = ZusTransferModuleViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    func removeModuleControllerFromStack() {
        let firstIndex = navigationController?.viewControllers.firstIndex {
            $0 is ZusTransferModuleViewController
        }
        guard let count = navigationController?.viewControllers.count,
              let index = firstIndex,
              count > index else { return }
        
        navigationController?.viewControllers.remove(at: index)
    }
}
