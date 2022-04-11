import CoreFoundationLib
import PLUI
import PLCommons
import PLCommonOperatives

protocol CharityTransferFormPresenterProtocol {
    var view: CharityTransferFormViewProtocol? { get set }
    func getLanguage() -> String
    func didSelectClose()
    func didSelectCloseProcess()
    func getSelectedAccountViewModels() -> [SelectableAccountViewModel]
    func getCharityTransferSettings() -> CharityTransferSettings
    func showAccountSelector()
    func updateTransferFormViewModel(with viewModel: CharityTransferFormViewModel)
    func confirmTransfer()
    func startValidation()
    func clearForm()
    func reloadAccounts()
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
    private let formValidator: CharityTransferValidator
    private let charityTransferSettings: CharityTransferSettings

    init(dependenciesResolver: DependenciesResolver,
         accounts: [AccountForDebit],
         selectedAccountNumber: String,
         formValidator: CharityTransferValidator,
         charityTransferSettings: CharityTransferSettings) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.formValidator = formValidator
        self.charityTransferSettings = charityTransferSettings
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
    
    func getCharityTransferSettings() -> CharityTransferSettings {
        charityTransferSettings
    }
    
    func showAccountSelector() {
        coordinator.showAccountSelector(selectedAccountNumber: selectedAccountNumber)
    }
    
    func updateTransferFormViewModel(with viewModel: CharityTransferFormViewModel) {
        transferFormViewModel = viewModel
    }
    
    func confirmTransfer() {
        guard let account = getSelectedAccountViewModel(),
              let transferFormViewModel = transferFormViewModel,
              let amount = transferFormViewModel.amount else { return }
        let model = CharityTransferModel(
            amount: amount,
            title: charityTransferSettings.transferTitle,
            account: account,
            recipientName: charityTransferSettings.transferRecipientName,
            recipientAccountNumber: transferFormViewModel.recipientAccountNumberUnformatted,
            transactionType: .charityTransfer,
            date: transferFormViewModel.date
        )
        coordinator.showConfirmation(with: model)
    }
    
    func getLanguage() -> String {
        dependenciesResolver.resolve(for: StringLoader.self).getCurrentLanguage().appLanguageCode
    }
    
    func startValidation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.validationAction()
        }
    }
    
    func validationAction() {
        guard let form = transferFormViewModel else { return }
        let invalidMessages = formValidator.validateForm(form: form)
        view?.showValidationMessages(messages: invalidMessages)
    }
    
    func clearForm() {
        transferFormViewModel = nil
    }
    
    func reloadAccounts() {
        view?.showLoader()
        Scenario(
            useCase: GetAccountsForDebitUseCase(
                transactionType: .charityTransfer,
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
