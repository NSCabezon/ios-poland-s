import Models
import Commons
import SANPLLibrary
import PLUI

protocol MobileTransferFormPresenterProtocol {
    var view: MobileTransferFormViewControllerProtocol? { get set }
    func didSelectClose()
    func didSelectCloseProcess()
    func getSelectedAccountViewModel() -> SelectableAccountViewModel?
    func showAccountSelectorScreen()
    func showContacts()
    func hasUserOneAccount() -> Bool
    func startValidation(for form: MobileTransferForm)
    func verifyPhoneNumber(phoneNumber: String)
    func viewDidLoad()
}

protocol MobileTransferFormAccountAndContactSelectable: AnyObject {
    func updateViewModel(with updatedViewModel: [SelectableAccountViewModel])
    func updateViewModel(with updatedViewModel: Contact?)
}

final class MobileTransferFormPresenter {
    weak var view: MobileTransferFormViewControllerProtocol?
    let dependenciesResolver: DependenciesResolver
    private var accounts: [SelectableAccountViewModel]
    private var contact: Contact?
    private var currentForm: MobileTransferForm?
    private var formValidator: MobileTransferFormValidator
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    private let queue: DispatchQueue
    private let noBlikContactDialog = NoBlikContactDialog()
    
    private var p2pAliasUseCase: P2pAliasProtocol {
        dependenciesResolver.resolve()
    }

    init(dependenciesResolver: DependenciesResolver,
         accounts: [SelectableAccountViewModel],
         contact: Contact?,
         formValidator: MobileTransferFormValidator,
         queue: DispatchQueue = .global()) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.contact = contact
        self.formValidator = formValidator
        self.queue = queue
    }
}

private extension MobileTransferFormPresenter {
    @objc func validationAction() {
        guard let form = currentForm else { return }
        let invalidMessages = formValidator.validateForm(form: form)
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

    func getSelectedAccountViewModel() -> SelectableAccountViewModel? {
        guard accounts.count > 1 else {
            return accounts.first
        }

        return accounts.first(where: { $0.isSelected })
    }
    
    func showAccountSelectorScreen() {
        coordinator.showAccountSelector(with: accounts)
    }
    
    func showContacts() {
        coordinator.showContacts()
    }
    
    func updateViewModel(with updatedViewModel: [SelectableAccountViewModel]) {
        accounts = updatedViewModel
        view?.setAccountViewModel()
    }
    
    func updateViewModel(with updatedViewModel: Contact?) {
        contact = updatedViewModel
        view?.fillWithContact(contact: contact)
    }
    
    func hasUserOneAccount() -> Bool {
        accounts.count == 1
    }
    
    func startValidation(for form: MobileTransferForm) {
        currentForm = form
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.validationAction()
        }
    }
    
    func viewDidLoad() {
        view?.fillWithContact(contact: contact)
    }
    
    func verifyPhoneNumber(phoneNumber: String) {
        view?.showLoader()
        
        Scenario(useCase: p2pAliasUseCase, input: .init(msisdn: phoneNumber))
            .execute(on: queue)
            .onSuccess { [weak self] result in
                self?.view?.hideLoader(completion: {
                    let mapper = MobileTransferMapper()
                    guard let currentForm = self?.currentForm, let account = self?.getSelectedAccountViewModel() else { return }
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
