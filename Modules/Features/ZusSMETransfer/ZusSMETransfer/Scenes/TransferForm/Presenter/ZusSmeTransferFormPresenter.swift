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
    func didSelectCloseProcess()
    func updateTransferFormViewModel(with viewModel: ZusSmeTransferFormViewModel)
    func startValidation(with field: TransferFormCurrentActiveField)
    func getAccountRequiredLength() -> Int
    func showRecipientSelection()
    func checkIfHaveEnoughFounds(transferAmount: Decimal, completion: @escaping () -> Void)
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
    private let formValidator: ZusSmeTransferValidating
    private var maskAccount: String?
    private var vatAccountDetails: VATAccountDetails?
    
    private var getPopularAccountsUseCase: GetPopularAccountsUseCase {
        dependenciesResolver.resolve()
    }
    
    private var getVATAccountUseCase: GetVATAccountUseCase {
        dependenciesResolver.resolve()
    }
    
    
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
        formValidator = dependenciesResolver.resolve(for: ZusSmeTransferValidating.self)
    }
}

extension ZusSmeTransferFormPresenter: ZusSmeTransferFormPresenterProtocol {
    
    func viewDidLoad() {
        view?.showLoader()
        let taxAccountNumber = accounts.first(where: { $0.number == selectedAccountNumber })?.taxAccountNumber ?? ""
        let getVatAccountDetails = Scenario(useCase: getVATAccountUseCase,
                                            input: GetVATAccountUseCaseInput(accountNumber: taxAccountNumber))
        Scenario(useCase: getPopularAccountsUseCase,
                 input: GetPopularAccountsUseCaseInput(accountType: 80))
            .execute(on: dependenciesResolver.resolve(for: UseCaseHandler.self))
            .onSuccess({ [weak self] accounts in
                    guard let mask = accounts.numbers.first?.number else {
                        self?.showErrorView()
                        return
                    }
                    self?.maskAccount = mask
            })
            .thenIgnoringPreviousResult(scenario: {
                () -> Scenario<GetVATAccountUseCaseInput, GetVATAccountCaseOkOutput, StringErrorOutput>? in
                return getVatAccountDetails
            })
            .onSuccess({ [weak self] output in
                self?.vatAccountDetails = output.vatAccountDetails
                self?.view?.setVatAccountDetails(vatAccountDetails: output.vatAccountDetails)
            })
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.showErrorView()
                })
            }
            .finally({ [weak self] in
                self?.view?.hideLoader(completion: {})
            })
    }
    
    func getAccountRequiredLength() -> Int {
        formValidator.getAccountRequiredLength()
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
        view?.showErrorMessage(localized("pl_generic_alert_textTryLater"), onConfirm: { [weak self] in
            self?.coordinator.closeProcess()
        })
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
    
    func updateTransferFormViewModel(with viewModel: ZusSmeTransferFormViewModel) {
        transferFormViewModel = viewModel
    }
    
    func checkIfHaveEnoughFounds(transferAmount: Decimal, completion: @escaping () -> Void) {
        let transferDifference = (vatAccountDetails?.availableFunds ?? 0) - transferAmount
        if transferDifference < 0 {
            view?.showNotEnoughMoneyInfo(difference: abs(transferDifference), completion: completion)
        } else {
            completion()
        }
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
        view?.showLoader()
        selectedAccountNumber = number
        view?.setAccountViewModel()
        let taxAccountNumber = accounts.first(where: { $0.number == selectedAccountNumber })?.taxAccountNumber ?? ""
        Scenario(useCase: getVATAccountUseCase,
                        input: GetVATAccountUseCaseInput(accountNumber: taxAccountNumber))
            .execute(on: dependenciesResolver.resolve(for: UseCaseHandler.self))
            .onSuccess({ [weak self] output in
                self?.view?.hideLoader(completion: {
                    self?.vatAccountDetails = output.vatAccountDetails
                    self?.view?.setVatAccountDetails(vatAccountDetails: output.vatAccountDetails)
                })
            })
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.showErrorView()
                })
            }
    }
}
