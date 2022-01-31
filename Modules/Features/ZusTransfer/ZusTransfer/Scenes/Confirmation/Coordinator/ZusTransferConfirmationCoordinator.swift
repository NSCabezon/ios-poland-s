
import UI
import PLUI
import Commons
import PLCommons
import SANPLLibrary
import PLCryptography

public protocol ZusTransferConfirmationCoordinatorProtocol {
    func pop()
    func backToTransfer()
    func showSummary(with model: ZusTransferSummary)
}

public final class ZusTransferConfirmationCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let model: ZusTransferModel

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         model: ZusTransferModel) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.model = model
        setupDependencies()
    }
    
    public func start() {
        let controller =  dependenciesEngine.resolve(for: ZusTransferConfirmationViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
}

private extension ZusTransferConfirmationCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: ZusTransferConfirmationCoordinatorProtocol.self) { _ in
            self
        }
        dependenciesEngine.register(for: ZusTransferConfirmationPresenterProtocol.self) { [weak self] resolver in
            ZusTransferConfirmationPresenter(dependenciesResolver: resolver, model: self?.model)
        }
        dependenciesEngine.register(for: ZusTransferConfirmationViewController.self) { resolver in
            var presenter = resolver.resolve(for: ZusTransferConfirmationPresenterProtocol.self)
            let viewController =  ZusTransferConfirmationViewController(
                presenter: presenter
            )
            presenter.view = viewController
            return viewController
        }
        dependenciesEngine.register(for: AcceptZusTransactionProtocol.self) { resolver in
            AcceptZusTransactionUseCase(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: PLTrustedHeadersGenerable.self) { resolver in
             PLTrustedHeadersProvider(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: PLDomesticTransactionParametersGenerable.self) { _ in
             PLDomesticTransactionParametersProvider()
        }
        dependenciesEngine.register(for: PLTransactionParametersProviderProtocol.self) { resolver in
             PLTransactionParametersProvider(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: ZusTransferSummaryMapping.self) { _ in
            ZusTransferSummaryMapper()
        }
        dependenciesEngine.register(for: ZusTransferSendMoneyInputMapping.self) { resolver in
            ZusTransferSendMoneyInputMapper(dependenciesResolver: resolver)
        }
    }
}

extension ZusTransferConfirmationCoordinator: ZusTransferConfirmationCoordinatorProtocol {

    public func pop() {
        navigationController?.popViewController(animated: true)
    }

    public func backToTransfer() {
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
    
    public func showSummary(with model: ZusTransferSummary) {
        let coordinator = ZusTransferSummaryCoordinator(dependenciesResolver: dependenciesEngine,
                                                        navigationController: navigationController,
                                                        summary: model)
        coordinator.start()
    }
}

