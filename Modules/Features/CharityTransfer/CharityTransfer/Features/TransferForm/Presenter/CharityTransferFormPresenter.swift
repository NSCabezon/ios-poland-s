import Commons
import PLUI
import PLCommons

protocol CharityTransferFormPresenterProtocol {
    var view: CharityTransferFormViewProtocol? { get set }
    func didSelectClose()
    func didSelectCloseProcess()
    func getAccounts() -> [SelectableAccountViewModel]
    func showAccountSelector()
}

public protocol CharityTransferFormAccountSelectable: AnyObject {
    func updateViewModel(with updatedViewModel: [SelectableAccountViewModel])
}

final class CharityTransferFormPresenter {
    weak var view: CharityTransferFormViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private var accounts: [SelectableAccountViewModel]
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    
    init(dependenciesResolver: DependenciesResolver,
         accounts: [SelectableAccountViewModel]) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
    }
}

extension CharityTransferFormPresenter: CharityTransferFormPresenterProtocol {
    func didSelectClose() {
        coordinator.pop()
    }
    
    func didSelectCloseProcess() {
        let dialog = confirmationDialogFactory.createEndProcessDialog {
            [weak self] in
            self?.coordinator.closeProcess()
        } declineAction: {}
        view?.showDialog(dialog)
    }
    
    func getAccounts() -> [SelectableAccountViewModel] {
        accounts
    }
    
    func showAccountSelector() {
        coordinator.showAccountSelector()
    }
}

private extension CharityTransferFormPresenter {
    var coordinator: CharityTransferFormCoordinatorProtocol {
        dependenciesResolver.resolve(for: CharityTransferFormCoordinatorProtocol.self)
    }
}

extension CharityTransferFormPresenter: CharityTransferFormAccountSelectable {
    func updateViewModel(with updatedViewModel: [SelectableAccountViewModel]) {
        accounts = updatedViewModel
        view?.setAccountViewModel()
    }
}
