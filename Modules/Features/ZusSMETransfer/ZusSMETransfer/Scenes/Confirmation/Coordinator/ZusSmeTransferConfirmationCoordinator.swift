import UI
import PLUI
import CoreFoundationLib
import PLCommons
import SANPLLibrary
import PLCryptography
import PLCommonOperatives

protocol ZusSmeTransferConfirmationCoordinatorProtocol {
    func pop()
    func backToTransfer()
    func showSummary(with model: ZusSmeSummaryModel)
    func closeAuthorization()
}

final class ZusSmeTransferConfirmationCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let model: ZusSmeTransferModel

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         model: ZusSmeTransferModel) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.model = model
        setupDependencies()
    }
    
    func start() {
        let controller =  dependenciesEngine.resolve(for: ZusSmeTransferConfirmationViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
}

private extension ZusSmeTransferConfirmationCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: ZusSmeTransferConfirmationCoordinatorProtocol.self) { _ in
            self
        }
        dependenciesEngine.register(for: ZusSmeTransferConfirmationPresenterProtocol.self) { [weak self] resolver in
            ZusSmeTransferConfirmationPresenter(dependenciesResolver: resolver, model: self?.model)
        }
        dependenciesEngine.register(for: ZusSmeTransferConfirmationViewController.self) { resolver in
            var presenter = resolver.resolve(for: ZusSmeTransferConfirmationPresenterProtocol.self)
            let viewController =  ZusSmeTransferConfirmationViewController(
                presenter: presenter
            )
            presenter.view = viewController
            return viewController
        }
        dependenciesEngine.register(for: AcceptZusSmeTransactionProtocol.self) { resolver in
            AcceptZusSmeTransactionUseCase(dependenciesResolver: resolver)
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
        dependenciesEngine.register(for: ZusSmeTransferSummaryMapping.self) { _ in
            ZusSmeTransferSummaryMapper()
        }
        dependenciesEngine.register(for: ZusSmeTransferSendMoneyInputMapping.self) { resolver in
            ZusSmeTransferSendMoneyInputMapper(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: PenndingChallengeUseCaseProtocol.self) { resolver in
            PenndingChallengeUseCase(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: NotifyDeviceUseCaseProtocol.self) { resolver in
            NotifyDeviceUseCase(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: AuthorizeTransactionUseCaseProtocol.self) { resolver in
            AuthorizeTransactionUseCase(dependenciesResolver: resolver)
        }
    }
}

extension ZusSmeTransferConfirmationCoordinator: ZusSmeTransferConfirmationCoordinatorProtocol {

    func pop() {
        navigationController?.popViewController(animated: true)
    }

    func backToTransfer() {
        let accountSelectorViewControllerIndex = navigationController?.viewControllers.firstIndex {
            $0 is AccountSelectorViewController
        }
        guard let accountSelectorViewControllerIndex = accountSelectorViewControllerIndex,
              let parentController = navigationController?.viewControllers[safe: accountSelectorViewControllerIndex - 1] else {
            let zusTransferFormViewControllerIndex = navigationController?.viewControllers.firstIndex {
                $0 is ZusSmeTransferFormViewController
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
    
    func showSummary(with model: ZusSmeSummaryModel) {
        let coordinator = ZusSmeTransferSummaryCoordinator(dependenciesResolver: dependenciesEngine,
                                                           navigationController: navigationController,
                                                           summary: model)
        coordinator.start()
    }
    
    func closeAuthorization() {
        guard let confirmationVC = navigationController?.viewControllers.first(where: {
            $0 is ZusSmeTransferConfirmationViewController
        }) else { return }
        navigationController?.popToViewController(confirmationVC, animated: false)
    }
}

