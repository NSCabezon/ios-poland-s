import CoreFoundationLib
import Commons
import SANPLLibrary
import PLUI
import PLCommons

protocol MobileTransferFormPresenterProtocol {
    var view: MobileTransferFormViewControllerProtocol? { get set }
    func didSelectClose()
    func didSelectCloseProcess()
    func getSelectedAccount() -> AccountForDebit?
    func showAccountSelectorScreen()
    func showContacts()
    func hasUserOneAccount() -> Bool
    func startValidation(for form: MobileTransferForm, validateNumber: Bool)
    func verifyPhoneNumber(phoneNumber: String)
    func viewDidLoad()
}

protocol MobileTransferFormAccountAndContactSelectable: AnyObject {
    func updateSelectedAccountNumber(with number: String)
    func updateViewModel(with updatedViewModel: MobileContact?)
}

final class MobileTransferFormPresenter {
    weak var view: MobileTransferFormViewControllerProtocol?
    let dependenciesResolver: DependenciesResolver
    private var accounts: [AccountForDebit]
    private var contact: MobileContact?
    private var currentForm: MobileTransferForm?
    private var formValidator: MobileTransferFormValidator
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    private let noBlikContactDialog = NoBlikContactDialog()
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    private var p2pAliasUseCase: P2pAliasProtocol {
        dependenciesResolver.resolve()
    }
    private var selectedAccountNumber: String

    init(dependenciesResolver: DependenciesResolver,
         accounts: [AccountForDebit],
         contact: MobileContact?,
         selectedAccountNumber: String,
         formValidator: MobileTransferFormValidator) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.contact = contact
        self.formValidator = formValidator
    }
}

private extension MobileTransferFormPresenter {
    func validationAction(validateNumber: Bool) {
        guard let form = currentForm else { return }
        let invalidMessages = formValidator.validateForm(form: form, validateNumber: validateNumber)
        view?.showValidationMessages(messages: invalidMessages)
    }
    
    func handleServiceInaccessible() {
        view?.showServiceInaccessibleMessage(onConfirm: nil)
    }
}

extension MobileTransferFormPresenter: MobileTransferFormPresenterProtocol, MobileTransferFormAccountAndContactSelectable {
    
    func didSelectClose() {
        coordinator.pop()
    }

    func didSelectCloseProcess() {
        let dialog = confirmationDialogFactory.createEndProcessDialog {[weak self] in
            self?.coordinator.closeProcess()
        } declineAction: { }

        view?.showDialog(dialog)
    }

    func getSelectedAccount() -> AccountForDebit? {
        guard accounts.count > 1 else {
            return accounts.first
        }

        return accounts.first(where: { $0.number == selectedAccountNumber })
    }
    
    func showAccountSelectorScreen() {
        coordinator.showAccountSelector(with: accounts, selectedAccountNumber: selectedAccountNumber)
    }
    
    func showContacts() {
        coordinator.showContacts()
    }
    
    func updateSelectedAccountNumber(with number: String) {
        selectedAccountNumber = number
        view?.setAccountViewModel()
    }
    
    func updateViewModel(with updatedViewModel: MobileContact?) {
        contact = updatedViewModel
        view?.fillWithContact(contact: contact)
    }
    
    func hasUserOneAccount() -> Bool {
        accounts.count == 1
    }
    
    func startValidation(for form: MobileTransferForm, validateNumber: Bool) {
        currentForm = form
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.validationAction(validateNumber: validateNumber)
        }
    }
    
    func viewDidLoad() {
        view?.fillWithContact(contact: contact)
    }
    
    func verifyPhoneNumber(phoneNumber: String) {
        view?.showLoader()
        
        Scenario(useCase: p2pAliasUseCase, input: .init(msisdn: phoneNumber))
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] result in
                self?.view?.hideLoader(completion: {
                    let mapper = MobileTransferMapper()
                    guard let currentForm = self?.currentForm, let account = self?.getSelectedAccount() else { return }
                    let mobileTransfer = mapper.map(form: currentForm, account: account)
                    self?.coordinator.showConfirmation(viewModel: .init(transfer: mobileTransfer),
                                                       isDstAccInternal: result.isDstAccInternal,
                                                       dstAccNo: result.dstAccNo)
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    guard let useCaseError = GetP2pAliasErrorResult(rawValue: error.getErrorDesc() ?? "") else { return }
                    switch useCaseError {
                    case .aliasNotExsist:
                        guard let viewController = self?.view as? UIViewController else { return }
                        self?.noBlikContactDialog.showDialog(in: viewController)
                    case .genericError:
                        self?.handleServiceInaccessible()
                    }
                })
            }
    }
}

private extension MobileTransferFormPresenter {
    var coordinator: MobileTransferFormCoordinatorProtocol {
        dependenciesResolver.resolve(for: MobileTransferFormCoordinatorProtocol.self)
    }
}
