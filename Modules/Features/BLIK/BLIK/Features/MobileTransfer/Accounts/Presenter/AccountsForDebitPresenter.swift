import CoreFoundationLib
import Commons
import PLUI
import PLCommons

final class AccountsForDebitPresenter {

    weak var view: AccountSelectorViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private var accounts: [AccountForDebit]
    private var selectedAccountNumber: String
    private let sourceView: SourceView
    weak var selectableDelegate: FormAccountSelectable?
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    private let mapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)

    init(dependenciesResolver: DependenciesResolver,
         accounts: [AccountForDebit],
         selectedAccountNumber: String,
         sourceView: SourceView,
         selectableDelegate: FormAccountSelectable?) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.sourceView = sourceView
        self.selectableDelegate = selectableDelegate
    }
}

private extension AccountsForDebitPresenter {
    var coordinator: AccountsForDebitCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: AccountsForDebitCoordinatorProtocol.self)
    }
}

extension AccountsForDebitPresenter: AccountSelectorPresenterProtocol {
    func didSelectAccount(at index: Int) {
        selectedAccountNumber = accounts[index].number
        switch sourceView {
        case .contacts:
            coordinator.showTransferForm(accounts: accounts, selectedAccountNumber: selectedAccountNumber)
        case .form:
            selectableDelegate?.updateSelectedAccountNumber(selectedAccountNumber)
            didPressClose()
        }
        
    }
    
    func didPressClose() {
        coordinator.pop()
    }
    
    func viewDidLoad() {
        let viewModels = accounts.compactMap({ try? mapper.map($0, selectedAccountNumber: selectedAccountNumber) })
        view?.setViewModels(viewModels)
    }
    
    func didCloseProcess() {
        let dialog = confirmationDialogFactory.createEndProcessDialog {[weak self] in
            self?.coordinator.closeProcess()
        }
        declineAction: {}
        
        view?.showDialog(dialog)
    }
}
