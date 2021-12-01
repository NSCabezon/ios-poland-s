import Commons
import PLUI
import PLCommons

protocol CharityTransferFormPresenterProtocol {
    var view: CharityTransferFormViewProtocol? { get set }
    func didSelectClose()
    func didSelectCloseProcess()
    func getSelectedAccountViewModels() -> [SelectableAccountViewModel]
    func getSelectedAccountNumber() -> String
    func showAccountSelector()
    func updateTransferFormViewModel(with viewModel: CharityTransferFormViewModel)
    func confirmTransfer()
}

public protocol CharityTransferFormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(number: String)
}

final class CharityTransferFormPresenter {
    weak var view: CharityTransferFormViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private var accounts: [AccountForDebit]
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    private var transferFormViewModel: CharityTransferFormViewModel?
    private var selectedAccountNumber: String
    private let mapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)

    init(dependenciesResolver: DependenciesResolver,
         accounts: [AccountForDebit],
         selectedAccountNumber: String) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
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
    
    func getSelectedAccountViewModels() -> [SelectableAccountViewModel] {
        let selectebleAccountViewModels = accounts.compactMap({ try? mapper.map($0, selectedAccountNumber: selectedAccountNumber) })
        return selectebleAccountViewModels
    }
    
    func getSelectedAccountNumber() -> String {
        selectedAccountNumber
    }
    
    func showAccountSelector() {
        coordinator.showAccountSelector(selectedAccountNumber: selectedAccountNumber)
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
    
    func getSelectedAccountViewModel() -> AccountForDebit? {
        guard accounts.count > 1 else {
            return accounts.first
        }
        return accounts.first(where: { $0.number == selectedAccountNumber })
    }
}

extension CharityTransferFormPresenter: CharityTransferFormAccountSelectable {
    func updateSelectedAccountNumber(number: String) {
        selectedAccountNumber = number
        view?.setAccountViewModel()
    }
}
