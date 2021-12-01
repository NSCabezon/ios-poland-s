import Models
import Commons
import CoreFoundationLib
import PLUI
import PLCommons
import PLCommonOperatives
import CoreFoundationLib

protocol ContactsPresenterProtocol: MenuTextWrapperProtocol {
    var view: ContactsViewProtocol? { get set }
    func viewDidLoad()
    func didSelectClose()
    func showTransferForm()
    func didSelectContact(_ contact: Contact)
}

final class ContactsPresenter {
    weak var view: ContactsViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private let viewModelMapper = ContactViewModelMapper()
    private let accountsViewModelMapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
    private var contact: Contact?
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
    
    func didSelectContact(_ contact: Contact) {
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
    
    func verifyContacts(_ contacts: [Contact]) {
        let phoneNumbers = contacts.map { $0.phoneNumber }
        
        Scenario(useCase: verifyContactsUseCase, input: .init(phoneNumbers: phoneNumbers))
            .execute(on: useCaseHandler)
            .onSuccess {[weak self] numbers in
                self?.view?.hideLoader {
                    let filteredContacts = contacts.filter { contact in
                        numbers.phoneNumbers.contains { $0.unformattedNumber == contact.phoneNumber }
                    }

                    self?.view?.showEmptyView(filteredContacts.isEmpty)
                    guard let viewModels = self?.viewModelMapper.map(contacts: filteredContacts),
                          !viewModels.isEmpty else { return }
                    self?.view?.setViewModels(viewModels)
                }
            }
            .onError {[weak self] _ in
                self?.view?.hideLoader {
                    self?.handleServiceInaccessible()
                }
            }
    }
    
    func getAccountsAndHandleContact(_ contact: Contact?) {
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
    
    private func showErrorMessage() {
        let message = "#Nie udało się pobrać listy kont. Spróbuj pononownie później."
        view?.showErrorMessage(message, onConfirm: nil)
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
