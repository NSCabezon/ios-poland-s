import CoreFoundationLib
import PLUI
import PLCommons
import PLCommonOperatives

protocol ZusTransferFormPresenterProtocol: RecipientSelectorDelegate, ZusTransferFormAccountSelectable {
    var view: ZusTransferFormViewProtocol? { get set }
    func viewDidLoad()
    func getLanguage() -> String
    func didSelectClose()
    func didSelectCloseProcess()
    func getSelectedAccountViewModels() -> [SelectableAccountViewModel]
    func getSelectedAccountNumber() -> String
    func showAccountSelector()
    func updateTransferFormViewModel(with viewModel: ZusTransferFormViewModel)
    func showConfirmation()
    func startValidation(with field: TransferFormCurrentActiveField)
    func showRecipientSelection()
    func getAccountRequiredLength() -> Int
    func clearForm()
    func reloadAccounts()
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
        confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
        formValidator = dependenciesResolver.resolve(for: ZusTransferValidating.self)
    }
}

extension ZusTransferFormPresenter: ZusTransferFormPresenterProtocol {
    
    func viewDidLoad() {
        view?.showLoader()
        Scenario(useCase: GetPopularAccountsUseCase(dependenciesResolver: dependenciesResolver), input: GetPopularAccountsUseCaseInput(accountType: 80))
            .execute(on: dependenciesResolver.resolve(for: UseCaseHandler.self))
            .onSuccess({ [weak self] accounts in
                self?.view?.hideLoader(completion: {
                    guard let mask = accounts.numbers.first?.number else {
                        self?.showErrorView()
                        return
                    }
                    self?.maskAccount = mask
                })
            })
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.showErrorView()
                })
            }
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
    
    func showRecipientSelection() {
        coordinator.showRecipientSelection(with: maskAccount)
    }
    
    func getAccountRequiredLength() -> Int {
        formValidator.getAccountRequiredLength()
    }
    
    func clearForm() {
        transferFormViewModel = nil
    }
    
    func reloadAccounts() {
        view?.showLoader()
        Scenario(
            useCase: GetAccountsForDebitUseCase(
                transactionType: .zusTransfer,
                dependenciesResolver: dependenciesResolver
            )
        )
        .execute(on: dependenciesResolver.resolve())
        .onSuccess { [weak self] accounts in
            guard let self = self else { return }
            self.view?.hideLoader(completion: {
                if accounts.isEmpty {
                    self.showErrorView()
                    return
                }
                self.accounts = accounts
                if !accounts.contains(where: { $0.number == self.selectedAccountNumber }) {
                    self.selectedAccountNumber = accounts.first(where: { $0.defaultForPayments })?.number ?? ""
                }
                let mapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
                let models = accounts.compactMap({ try? mapper.map($0, selectedAccountNumber: self.selectedAccountNumber) })
                self.coordinator.updateAccounts(accounts: accounts)
                self.view?.reloadAccountsComponent(with: models)
            })
        }
        .onError { [weak self] _ in
            self?.view?.hideLoader(completion: {
                self?.showErrorView()
            })
        }
    }
    
    private func showErrorView() {
        view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: { [weak self] in
            self?.coordinator.closeProcess()
        })
    }
}

extension ZusTransferFormPresenter: RecipientSelectorDelegate {
    func didSelectRecipient(_ recipient: Recipient) {
        view?.updateRecipient(
            name: recipient.name,
            accountNumber: IBANFormatter.format(
                iban: IBANFormatter.formatIbanToNrb(for: recipient.accountNumber)
            )
        )
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
