import CoreFoundationLib
import PLUI
import PLCommons
import PLCommonOperatives

protocol ZusSmeTransferFormPresenterProtocol: RecipientSelectorDelegate, ZusSmeTransferFormAccountSelectable {
    var view: ZusSmeTransferFormViewProtocol? { get set }
    func viewDidLoad()
    func getLanguage() -> String
    func getSelectedAccountViewModels() -> [SelectableAccountViewModel]
    func showAccountSelector()
    func showRecipientSelection()
}

protocol ZusSmeTransferFormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(number: String)
}

final class ZusSmeTransferFormPresenter {
    weak var view: ZusSmeTransferFormViewProtocol?
    private let coordinator: ZusSmeTransferFormCoordinatorProtocol
    private let dependenciesResolver: DependenciesResolver
    private var accounts: [AccountForDebit]
    private var selectedAccountNumber: String
    private var transferFormViewModel: ZusSmeTransferFormViewModel?
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let mapper: SelectableAccountViewModelMapping
    private var maskAccount: String?
    
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
        coordinator = dependenciesResolver.resolve(for: ZusSmeTransferFormCoordinatorProtocol.self)
    }
}

extension ZusSmeTransferFormPresenter: ZusSmeTransferFormPresenterProtocol {
    
    func viewDidLoad() {
      //TODO: start GetPopularAccountsUseCase
    }
    
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
        let selectebleAccountViewModels = accounts.compactMap { try? mapper.map($0, selectedAccountNumber: selectedAccountNumber) }
        return selectebleAccountViewModels
    }
        
    func showAccountSelector() {
        coordinator.showAccountSelector(selectedAccountNumber: selectedAccountNumber)
    }
    
    func showRecipientSelection() {
        coordinator.showRecipientSelection(with: maskAccount)
    }
    
    func clearForm() {
        transferFormViewModel = nil
    }
    
    private func showErrorView() {
        view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: { [weak self] in
            self?.coordinator.closeProcess()
        })
    }
}

extension ZusSmeTransferFormPresenter: RecipientSelectorDelegate {
    func didSelectRecipient(_ recipient: Recipient) {
        view?.updateRecipient(
            name: recipient.name,
            accountNumber: IBANFormatter.format(
                iban: IBANFormatter.formatIbanToNrb(for: recipient.accountNumber)
            )
        )
    }
}

private extension ZusSmeTransferFormPresenter {
    func getSelectedAccountViewModel() -> AccountForDebit? {
        guard accounts.count > 1 else {
            return accounts.first
        }
        return accounts.first(where: { $0.number == selectedAccountNumber })
    }
}

extension ZusSmeTransferFormPresenter: ZusSmeTransferFormAccountSelectable {
    func updateSelectedAccountNumber(number: String) {
        selectedAccountNumber = number
        view?.setAccountViewModel()
    }
}
