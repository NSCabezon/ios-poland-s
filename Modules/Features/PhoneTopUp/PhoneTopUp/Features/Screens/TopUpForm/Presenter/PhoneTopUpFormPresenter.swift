//
//  PhoneTopUpPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 24/11/2021.
//

import Commons
import PLCommons
import Commons
import PLUI
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary


protocol PhoneTopUpFormPresenterProtocol: AccountForDebitSelectorDelegate, MobileContactsSelectorDelegate, OperatorSelectorDelegate {
    var view: PhoneTopUpFormViewProtocol? { get set }
    func viewDidLoad()
    func didSelectBack()
    func didSelectClose()
    func didSelectChangeAccount()
    func didTouchContactsButton()
    func didInputPartialPhoneNumber(_ number: String)
    func didInputFullPhoneNumber(_ number: String)
    func didTouchContinueButton()
    func didTouchOperatorSelectionButton()
}

final class PhoneTopUpFormPresenter {
    // MARK: Properties
    
    weak var view: PhoneTopUpFormViewProtocol?
    private weak var coordinator: PhoneTopUpFormCoordinatorProtocol?
    private let dependenciesResolver: DependenciesResolver
    private let accounts: [AccountForDebit]
    private let operators: [Operator]
    private let gsmOperators: [GSMOperator]
    private let internetContacts: [MobileContact]
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let accountMapper: SelectableAccountViewModelMapping
    private var selectedAccountNumber: String?
    private var selectedOperator: GSMOperator?
    private let getPhoneContactsUseCase: GetContactsUseCaseProtocol
    private let useCaseHandler: UseCaseHandler
    private let contactsPermissionHelper: ContactsPermissionHelperProtocol
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver,
         accounts: [AccountForDebit],
         operators: [Operator],
         gsmOperators: [GSMOperator],
         internetContacts: [MobileContact]) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.operators = operators
        self.gsmOperators = gsmOperators
        self.internetContacts = internetContacts
        coordinator = dependenciesResolver.resolve(for: PhoneTopUpFormCoordinatorProtocol.self)
        confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
        accountMapper = dependenciesResolver.resolve(for: SelectableAccountViewModelMapping.self)
        selectedAccountNumber = accounts.first(where: \.defaultForPayments)?.number
        self.getPhoneContactsUseCase = dependenciesResolver.resolve(for: GetContactsUseCaseProtocol.self)
        self.useCaseHandler = dependenciesResolver.resolve(for: UseCaseHandler.self)
        self.contactsPermissionHelper = dependenciesResolver.resolve(for: ContactsPermissionHelperProtocol.self)
    }
}

// MARK: PhoneTopUpFormPresenterProtocol
extension PhoneTopUpFormPresenter: PhoneTopUpFormPresenterProtocol {
    func viewDidLoad() {
        let viewModels = accounts.compactMap({ try? accountMapper.map($0, selectedAccountNumber: selectedAccountNumber) })
        view?.updateSelectedAccount(with: viewModels)
    }
    
    func didSelectBack() {
        coordinator?.back()
    }
    
    func didSelectClose() {
        let dialog = confirmationDialogFactory.createEndProcessDialog { [weak self] in
            self?.coordinator?.close()
        } declineAction: {}
        view?.showDialog(dialog)
    }
    
    func didSelectAccount(withAccountNumber accountNumber: String) {
        selectedAccountNumber = accountNumber
        let viewModels = accounts.compactMap({ try? accountMapper.map($0, selectedAccountNumber: selectedAccountNumber) })
        view?.updateSelectedAccount(with: viewModels)
    }
    
    func didSelectChangeAccount() {
        coordinator?.didSelectChangeAccount(availableAccounts: accounts, selectedAccountNumber: selectedAccountNumber)
    }
    
    func didTouchContactsButton() {
        if !internetContacts.isEmpty {
            coordinator?.showInternetContacts()
        } else {
            contactsPermissionHelper.authorizeContactsUse { [weak self] isAuthorized in
                if isAuthorized {
                    self?.showPhoneContacts()
                } else {
                    self?.view?.showContactsPermissionsDeniedDialog()
                }
            }
        }
    }
    
    func didInputPartialPhoneNumber(_ number: String) {
        view?.showOperatorSelection(with: nil)
    }
    
    func didInputFullPhoneNumber(_ number: String) {
        if let matchingOperator = matchOperator(with: number) {
            view?.showInvalidPhoneNumberError(false)
            view?.showOperatorSelection(with: matchingOperator)
        } else {
            view?.showInvalidPhoneNumberError(true)
            view?.showOperatorSelection(with: nil)
        }
    }
    
    func mobileContactsDidSelectContact(_ contact: MobileContact) {
        view?.updateContact(with: contact)
        didInputFullPhoneNumber(contact.phoneNumber.filter(\.isNumber))
    }
    
    func mobileContactDidSelectCloseProcess() {
        // we don't need to do anything here
    }
    
    func didTouchContinueButton() {
        #warning("todo: remove mock data once whole form is implemented")
        let account = AccountForDebit(id: "id",
                                      name: "Konto marzeń",
                                      number: "31109015220000000052017788",
                                      availableFunds: Money(amount: Decimal(500.0), currency: "PLN"),
                                      defaultForPayments: true,
                                      type: .DEPOSIT,
                                      accountSequenceNumber: 0,
                                      accountType: 34)
        let formData = TopUpModel(amount: Decimal(40.44),
                                   account: account,
                                   recipientNumber: "+48 558 457 348",
                                   recipientName: "Jan Bankowy",
                                   date: Date())
        coordinator?.showTopUpConfirmation(with: formData)
    }
    
    func didTouchOperatorSelectionButton() {
        coordinator?.showOperatorSelection(currentlySelectedOperatorId: selectedOperator?.id)
    }
    
    func didSelectOperator(_ gsmOperator: GSMOperator) {
        selectedOperator = gsmOperator
    }
}

private extension PhoneTopUpFormPresenter {
    func matchOperator(with number: String) -> Operator? {
        return operators.first(where: { $0.prefixes.first(where: { number.starts(with: $0) }) != nil })
    }
    
    func showPhoneContacts() {
        Scenario(useCase: getPhoneContactsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess {[weak self] output in
                self?.coordinator?.showPhoneContacts(output.contacts)
            }
    }
}
