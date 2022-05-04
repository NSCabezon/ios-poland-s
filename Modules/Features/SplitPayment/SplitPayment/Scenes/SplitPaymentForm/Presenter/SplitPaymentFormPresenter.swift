import CoreFoundationLib
import PLUI
import PLCommons
import PLCommonOperatives

protocol SplitPaymentFormPresenterProtocol: RecipientSelectorDelegate, SplitPaymentFormAccountSelectable {
    var view: SplitPaymentFormViewProtocol? { get set }
    func getLanguage() -> String
    func didSelectClose()
    func didSelectCloseProcess()
    func getSelectedAccountViewModels() -> [SelectableAccountViewModel]
    func getSelectedAccountNumber() -> String
    func showAccountSelector()
    func updateTransferFormViewModel(with viewModel: SplitPaymentFormViewModel)
    func showConfirmation()
    func startValidation(with field: TransferFormCurrentActiveField)
    func showRecipientSelection()
    func getAccountRequiredLength() -> Int
    func clearForm()
    func reloadAccounts()
    func showMoreInfoAboutWhiteList()
}

public protocol SplitPaymentFormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(number: String)
}

final class SplitPaymentFormPresenter {
    weak var view: SplitPaymentFormViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var accounts: [AccountForDebit]
    private var selectedAccountNumber: String
    private var transferFormViewModel: SplitPaymentFormViewModel?
    private var confirmationDialogFactory: ConfirmationDialogProducing
    private let mapper: SelectableAccountViewModelMapping
    private let formValidator: SplitPaymentValidating
    
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
        formValidator = dependenciesResolver.resolve(for: SplitPaymentValidating.self)
    }
}

extension SplitPaymentFormPresenter: SplitPaymentFormPresenterProtocol {
    
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
    
    func updateTransferFormViewModel(with viewModel: SplitPaymentFormViewModel) {
        transferFormViewModel = viewModel
    }
    
    func showConfirmation() {
        guard let account = getSelectedAccountViewModel(),
              let transferFormViewModel = transferFormViewModel else { return }
        let model = SplitPaymentModel(account: account,
                                      recipientName: transferFormViewModel.recipient,
                                      recipientAccountNumber: transferFormViewModel.recipientAccountNumber,
                                      nipNumber: transferFormViewModel.nip,
                                      grossAmount: transferFormViewModel.grossAmount,
                                      vatAmount: transferFormViewModel.vatAmount,
                                      invoiceTitle: transferFormViewModel.invoiceTitle,
                                      title: transferFormViewModel.title,
                                      date: transferFormViewModel.date)
        coordinator.showConfiramtion(model: model)
    }
        
    func startValidation(with field: TransferFormCurrentActiveField) {
        validationAction(with: field)
    }
    
    func validationAction(with field: TransferFormCurrentActiveField) {
        guard let form = transferFormViewModel else { return }
        let invalidMessages = formValidator.validateForm(
            form: form,
            with: field
        )
        view?.showValidationMessages(with: invalidMessages)
    }
    
    func showRecipientSelection() {
        coordinator.showRecipientSelection()
    }
    
    func showMoreInfoAboutWhiteList() {
        coordinator.showMoreInfoAboutWhiteList()
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
                transactionType: .splitPayment,
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

extension SplitPaymentFormPresenter: RecipientSelectorDelegate {
    func didSelectRecipient(_ recipient: Recipient) {
        view?.updateRecipient(
            name: recipient.name,
            accountNumber: IBANFormatter.format(
                iban: IBANFormatter.formatIbanToNrb(for: recipient.accountNumber)
            )
        )
    }
}

private extension SplitPaymentFormPresenter {
    var coordinator: SplitPaymentFormCoordinatorProtocol {
        dependenciesResolver.resolve(for: SplitPaymentFormCoordinatorProtocol.self)
    }
    
    func getSelectedAccountViewModel() -> AccountForDebit? {
        guard accounts.count > 1 else {
            return accounts.first
        }
        return accounts.first(where: { $0.number == selectedAccountNumber })
    }
}

extension SplitPaymentFormPresenter: SplitPaymentFormAccountSelectable {
    func updateSelectedAccountNumber(number: String) {
        selectedAccountNumber = number
        view?.setAccountViewModel()
    }
}
