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
    
    public func start() {
       //TODO: later
    }
    
    // MARK: Dependencies
    
    private func setUpDependencies(maskAccount: String?) {
        dependenciesEngine.register(for: RecipientSelectionCoordinatorProtocol.self) { _ in
            return self
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
