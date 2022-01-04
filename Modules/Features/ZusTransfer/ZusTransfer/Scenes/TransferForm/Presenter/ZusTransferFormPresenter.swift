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
