import CoreFoundationLib
import PLUI
import PLCommons

final class ZusSmeAccountSelectorPresenter {
    weak var view: AccountSelectorViewProtocol?
    private weak var selectableDelegate: FormAccountSelectable?
    private let dependenciesResolver: DependenciesResolver
    private var accounts: [AccountForDebit] = []
    private let sourceView: SourceView
    private var selectedAccountNumber: String?
    private let coordinator: ZusSmeAccountSelectorCoordinatorProtocol
    private let confirmationDialogFactory: ConfirmationDialogProducing

    init(
        dependenciesResolver: DependenciesResolver,
        accounts: [AccountForDebit],
        selectedAccountNumber: String?,
        sourceView: SourceView,
        selectableDelegate: FormAccountSelectable?
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.sourceView = sourceView
        self.selectableDelegate = selectableDelegate
        self.selectedAccountNumber = selectedAccountNumber
        confirmationDialogFactory = dependenciesResolver.resolve()
        coordinator = dependenciesResolver.resolve()
    }
    
    func updateAccounts(accounts: [AccountForDebit]) {
        self.accounts = accounts
    }
}

extension ZusSmeAccountSelectorPresenter: AccountSelectorPresenterProtocol {
    func didSelectAccount(at index: Int) {
        guard let selectedAccountNumber = accounts[safe: index]?.number else { return }
        switch sourceView {
        case .sendMoney:
            coordinator.showTransferForm(accounts: accounts,
                                         selectedAccountNumber: selectedAccountNumber)
        case .form:
            didPressClose()
            selectableDelegate?.updateSelectedAccountNumber(number: selectedAccountNumber)
        }
    }
    
    func didPressClose() {
        coordinator.pop()
    }
    
    func viewDidLoad() {
        let mapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        let accoutViewModels = accounts.compactMap { try? mapper.map($0, selectedAccountNumber: selectedAccountNumber) }
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
