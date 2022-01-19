import CoreFoundationLib
import Commons
import PLUI
import PLCommons

final class CharityTransferAccountSelectorPresenter {

    weak var view: AccountSelectorViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private var accounts: [AccountForDebit] = []
    private let sourceView: SourceView
    private var selectedAccountNumber: String
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    weak var selectableDelegate: FormAccountSelectable?

    init(dependenciesResolver: DependenciesResolver,
         accounts: [AccountForDebit],
         selectedAccountNumber: String,
         sourceView: SourceView,
         selectableDelegate: FormAccountSelectable?) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.sourceView = sourceView
        self.selectableDelegate = selectableDelegate
        self.selectedAccountNumber = selectedAccountNumber
    }
}

private extension CharityTransferAccountSelectorPresenter {
    var coordinator: CharityTransferAccountSelectorCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: CharityTransferAccountSelectorCoordinatorProtocol.self)
    }
}

extension CharityTransferAccountSelectorPresenter: AccountSelectorPresenterProtocol {
    func didSelectAccount(at index: Int) {
        selectedAccountNumber = accounts[index].number
        switch sourceView {
        case .sendMoney:
            coordinator.showTransferForm(accounts: accounts,
                                         selectedAccountNumber: selectedAccountNumber)
        case .form:
            selectableDelegate?.updateSelectedAccountNumber(number: selectedAccountNumber)
            didPressClose()
        }
        
    }
    
    func didPressClose() {
        coordinator.pop()
    }
    
    func viewDidLoad() {
        let mapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        let accoutViewModels = accounts.compactMap({ try? mapper.map($0, selectedAccountNumber: selectedAccountNumber) })
        view?.setViewModels(accoutViewModels)
    }
    
    func didCloseProcess() {
        let dialog = confirmationDialogFactory.createEndProcessDialog {[weak self] in
            self?.coordinator.closeProcess()
        }
        declineAction: {}
        
        view?.showDialog(dialog)
    }
}
