import Commons
import PLUI
import PLCommons

protocol CharityTransferFormPresenterProtocol {
    var view: CharityTransferFormViewProtocol? { get set }
    func didSelectClose()
    func didSelectCloseProcess()
    func getAccounts() -> [SelectableAccountViewModel]
    func showAccountSelector()
    func updateTransferFormViewModel(with viewModel: CharityTransferFormViewModel)
    func confirmTransfer()
}

public protocol CharityTransferFormAccountSelectable: AnyObject {
    func updateViewModel(with updatedViewModel: [SelectableAccountViewModel])
}

final class CharityTransferFormPresenter {
    weak var view: CharityTransferFormViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private var accounts: [SelectableAccountViewModel]
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    private var transferFormViewModel: CharityTransferFormViewModel?

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
    
    func updateTransferFormViewModel(with viewModel: CharityTransferFormViewModel) {
        transferFormViewModel = viewModel
    }
    
    func confirmTransfer() {
        guard let account = getSelectedAccountViewModel(),
              let transferFormViewModel = transferFormViewModel else { return }
        let model = CharityTransferModel(
            amount: transferFormViewModel.amount,
            title: localized("pl_foundtrans_text_titleTransFound"),
            account: account,
            recipientName: localized("pl_foundtrans_text_RecipFoudSant"),
            transactionType: .charityTransfer,
            date: Date()
        )
        coordinator.showConfirmation(with: model)
    }
}

private extension CharityTransferFormPresenter {
    var coordinator: CharityTransferFormCoordinatorProtocol {
        dependenciesResolver.resolve(for: CharityTransferFormCoordinatorProtocol.self)
    }
    
    func getSelectedAccountViewModel() -> SelectableAccountViewModel? {
        guard accounts.count > 1 else {
            return accounts.first
        }
        return accounts.first(where: { $0.isSelected })
    }
}

extension CharityTransferFormPresenter: CharityTransferFormAccountSelectable {
    func updateViewModel(with updatedViewModel: [SelectableAccountViewModel]) {
        accounts = updatedViewModel
        view?.setAccountViewModel()
    }
}
