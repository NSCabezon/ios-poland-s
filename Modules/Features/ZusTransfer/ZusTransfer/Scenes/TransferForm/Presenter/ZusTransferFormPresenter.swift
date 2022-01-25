import Commons
import PLUI
import PLCommons

protocol ZusTransferFormPresenterProtocol {
    var view: ZusTransferFormViewProtocol? { get set }
    func getLanguage() -> String
    func didSelectClose()
    func didSelectCloseProcess()
    func getSelectedAccountViewModels() -> [SelectableAccountViewModel]
    func getSelectedAccountNumber() -> String
    func showAccountSelector()
    func updateTransferFormViewModel(with viewModel: ZusTransferFormViewModel)
    func showConfirmation()
    func startValidation(with field: TransferFormCurrentActiveField)
}

public protocol ZusTransferFormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(number: String)
}

final class ZusTransferFormPresenter {
    weak var view: ZusTransferFormViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var accounts: [AccountForDebit]
    private var selectedAccountNumber: String
    private var transferFormViewModel: ZusTransferFormViewModel?
    private var confirmationDialogFactory: ConfirmationDialogProducing
    private let mapper: SelectableAccountViewModelMapping
    private let formValidator: ZusTransferValidating
    #warning("maskAccount should be changed")
    //TODO: get maskAccount from Api
    private let maskAccount = "60000002026"
    
    init(
        dependenciesResolver: DependenciesResolver,
        accounts: [AccountForDebit],
        selectedAccountNumber: String
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
        mapper = dependenciesResolver.resolve(for: SelectableAccountViewModelMapping.self)
        confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
        formValidator = dependenciesResolver.resolve(for: ZusTransferValidating.self)
    }
}

extension ZusTransferFormPresenter: ZusTransferFormPresenterProtocol {
    
    func getLanguage() -> String {
        dependenciesResolver.resolve(for: StringLoader.self).getCurrentLanguage().appLanguageCode
    }
    
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
    
    func updateTransferFormViewModel(with viewModel: ZusTransferFormViewModel) {
        transferFormViewModel = viewModel
    }
    
    func showConfirmation() {
        guard let account = getSelectedAccountViewModel(),
              let transferFormViewModel = transferFormViewModel else { return }
        let model = ZusTransferModel(
            amount: transferFormViewModel.amount ?? 0,
            title: transferFormViewModel.title,
            account: account,
            recipientName: transferFormViewModel.recipient,
            recipientAccountNumber: transferFormViewModel.recipientAccountNumber,
            transactionType: .zusTransfer,
            date: transferFormViewModel.date
        )
        coordinator.showConfiramtion(model: model)
    }
        
    func startValidation(with field: TransferFormCurrentActiveField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.validationAction(with: field)
        }
    }
    
    func validationAction(with field: TransferFormCurrentActiveField) {
        guard let form = transferFormViewModel else { return }
        let invalidMessages = formValidator.validateForm(
            form: form,
            with: field,
            maskAccount: maskAccount
        )
        view?.showValidationMessages(with: invalidMessages)
    }
}

private extension ZusTransferFormPresenter {
    var coordinator: ZusTransferFormCoordinatorProtocol {
        dependenciesResolver.resolve(for: ZusTransferFormCoordinatorProtocol.self)
    }
    
    func getSelectedAccountViewModel() -> AccountForDebit? {
        guard accounts.count > 1 else {
            return accounts.first
        }
        return accounts.first(where: { $0.number == selectedAccountNumber })
    }
}

extension ZusTransferFormPresenter: ZusTransferFormAccountSelectable {
    func updateSelectedAccountNumber(number: String) {
        selectedAccountNumber = number
        view?.setAccountViewModel()
    }
}
