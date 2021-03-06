import CoreFoundationLib
import PLUI
import PLCommons
import PLCommonOperatives

protocol ContactsPresenterProtocol: MenuTextWrapperProtocol {
    var view: ContactsViewProtocol? { get set }
    func viewDidLoad()
    func didSelectClose()
    func showTransferForm()
    func didSelectContact(_ contact: MobileContact)
}

final class ContactsPresenter {
    weak var view: ContactsViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private let viewModelMapper = ContactViewModelMapper()
    private let accountsViewModelMapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
    private var contact: MobileContact?
    weak var selectableContactDelegate: FormContactSelectable?
    
    private var getContactsUseCase: GetContactsUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    private var verifyContactsUseCase: PhoneVerificationProtocol {
        dependenciesResolver.resolve()
    }
    
    private var getAccountsUseCase: GetAccountsForDebitProtocol {
        dependenciesResolver.resolve()
    }
    
    private var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve(for: UseCaseHandler.self)
    }

    init(dependenciesResolver: DependenciesResolver,
         selectableContactDelegate: FormContactSelectable?) {
        self.dependenciesResolver = dependenciesResolver
        self.selectableContactDelegate = selectableContactDelegate
    }
}

private extension ContactsPresenter {
    var coordinator: ContactsCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: ContactsCoordinatorProtocol.self)
    }
}

extension ContactsPresenter: ContactsPresenterProtocol {
    func viewDidLoad() {
        getContacts()
    }
    
    func didSelectClose() {
        coordinator.pop()
    }
    

    func showTransferForm() {
        if let selectableContactDelegate = selectableContactDelegate {
            coordinator.pop()
            selectableContactDelegate.updateViewModel(with: nil)
        } else {
            getAccountsAndHandleContact(nil)
        }
    }
    
    func didSelectContact(_ contact: MobileContact) {
        if let selectableContactDelegate = selectableContactDelegate {
            coordinator.pop()
            selectableContactDelegate.updateViewModel(with: contact)
        } else {
            getAccountsAndHandleContact(contact)
        }
    }
}

private extension ContactsPresenter {
    
    func getContacts() {
        view?.showLoader()

        Scenario(useCase: getContactsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess {[weak self] output in
                self?.verifyContacts(output.contacts)
            }
            .onError {[weak self] _ in
                self?.view?.hideLoader {
                    self?.handleServiceInaccessible()
                }
            }
        
    }
    
    func verifyContacts(_ contacts: [MobileContact]) {
        if contacts.isEmpty {
            view?.hideLoader { [weak self] in
                self?.view?.showEmptyView(true)
                
            }
            return
        }
        let phoneNumbers = contacts.map { $0.phoneNumber }
        let phoneNumbersChunked = phoneNumbers.chunks(500)
        var output: [HashedNumberMetadata] = []
        let multiScenario = MultiScenario(handledOn: dependenciesResolver.resolve())
        for phonePackage in phoneNumbersChunked {
            multiScenario.addScenario(Scenario(useCase: verifyContactsUseCase, input: .init(phoneNumbers: phonePackage))) {  (_, scenarioOutput, _) in
                output.append(contentsOf: scenarioOutput.phoneNumbers)
            }
        }
        multiScenario
            .asScenarioHandler()
            .onSuccess { [weak self] in
                self?.view?.hideLoader {
                    let filteredContacts = contacts.filter { contact in
                        output.contains { $0.unformattedNumber == contact.phoneNumber }
                    }
                    self?.view?.showEmptyView(filteredContacts.isEmpty)
                    guard let viewModels = self?.viewModelMapper.map(contacts: filteredContacts),
                          !viewModels.isEmpty else { return }
                    self?.view?.setViewModels(viewModels)
                }
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader {
                    self?.handleServiceInaccessible()
                }
            }
    }
    
    func getAccountsAndHandleContact(_ contact: MobileContact?) {
        view?.showLoader()
        self.contact = contact

        Scenario(useCase: getAccountsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess {[weak self] accounts in
                self?.view?.hideLoader {
                    self?.showNextScreen(with: accounts)
                }
            }
            .onError {[weak self] _ in
                self?.view?.hideLoader {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                }
            }
    }

    func showNextScreen(with accounts: [AccountForDebit]) {
        let defaultForPayments = accounts.first(where: { $0.defaultForPayments == true })
        guard defaultForPayments == nil, accounts.count > 1 else {
            coordinator.showForm(with: accounts, contact: contact)
            return
        }
        coordinator.showAccountSelector(with: accounts, contact: contact)
    }

    func handleServiceInaccessible() {
        view?.showServiceInaccessibleMessage {[weak self] in
            self?.coordinator.pop()
        }
    }
}
