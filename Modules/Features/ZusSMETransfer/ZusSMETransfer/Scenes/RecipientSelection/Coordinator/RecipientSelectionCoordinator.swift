import CoreFoundationLib
import PLCommons
import UI
import PLUI

protocol RecipientSelectionCoordinatorProtocol: AnyObject {
    func back()
    func didSelectRecipient(_ recipient: Recipient)
    func closeProcess()
}

protocol RecipientSelectorDelegate: AnyObject {
    func didSelectRecipient(_ recipient: Recipient)
}

final class RecipientSelectionCoordinator {
    private let navigationController: UINavigationController?
    private weak var delegate: RecipientSelectorDelegate?
    private let dependenciesEngine: DependenciesDefault
    
    init(
        dependenciesResolver: DependenciesResolver,
        delegate: RecipientSelectorDelegate?,
        navigationController: UINavigationController?,
        maskAccount: String?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.delegate = delegate
        self.setUpDependencies(maskAccount: maskAccount)
    }
    
    func start() {
        let recipientSelectionController = dependenciesEngine.resolve(
            for: RecipientSelectionViewController.self
        )
        navigationController?.pushViewController(recipientSelectionController, animated: true)
    }
    
    // MARK: Dependencies
    
    private func setUpDependencies(maskAccount: String?) {
        dependenciesEngine.register(for: RecipientSelectionCoordinatorProtocol.self) { _ in
            return self
        }
        dependenciesEngine.register(for: RecipientSelectionPresenterProtocol.self) { resolver in
            RecipientSelectionPresenter(
                dependenciesResolver: resolver,
                maskAccount: maskAccount
            )
        }
        dependenciesEngine.register(for: RecipientSelectionViewController.self) { resolver in
            let presenter = resolver.resolve(for: RecipientSelectionPresenterProtocol.self)
            let confirmationDialogFactory = resolver.resolve(for: ConfirmationDialogProducing.self)
            let controller = RecipientSelectionViewController(
                presenter: presenter,
                confirmationDialogFactory: confirmationDialogFactory
            )
            presenter.view = controller
            return controller
        }
        dependenciesEngine.register(for: GetRecipientsUseCaseProtocol.self) { resolver in
            GetRecipientsUseCase(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: RecipientMapping.self) { _ in
            RecipientMapper()
        }
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            ConfirmationDialogFactory()
        }
    }
}

extension RecipientSelectionCoordinator: RecipientSelectionCoordinatorProtocol {
    func closeProcess() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func didSelectRecipient(_ recipient: Recipient) {
        delegate?.didSelectRecipient(recipient)
        navigationController?.popViewController(animated: true)
    }
}
