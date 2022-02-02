//
//  PhoneTopUpPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 24/11/2021.
//

import CoreFoundationLib
import PLCommons
import PLUI
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
    func didSelectTopUpAmount(_ value: TopUpValue?)
    func didTouchContinueButton()
    func didTouchOperatorSelectionButton()
}

final class PhoneTopUpFormPresenter {
    private enum InputPhoneNumber {
        case partial(number: String)
        case full(number: String)
        
        var number: String {
            switch self {
            case .partial(let number):
                return number
            case .full(let number):
                return number
            }
        }
    }
    
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
    private let getPhoneContactsUseCase: GetContactsUseCaseProtocol
    private let useCaseHandler: UseCaseHandler
    private let contactsPermissionHelper: ContactsPermissionHelperProtocol
    private let polishContactsFilter: PolishContactsFiltering
    
    private var selectedAccountNumber: String?
    
    private var phoneNumber: InputPhoneNumber = .partial(number: "") {
        didSet {
            view?.updatePhoneInput(with: phoneNumber.number)
            validatePhoneNumber()
            updateRecipientName()
            updateOperator()
        }
    }
    
    private var selectedGsmOperator: GSMOperator? {
        didSet {
            view?.updateOperatorSelection(with: selectedGsmOperator)
            let matchingOperator = operators.first(where: { $0.id == selectedGsmOperator?.id })
            selectedOperator = matchingOperator
        }
    }
    
    private var selectedOperator: Operator? {
        didSet {
            selectedTopUpValue = nil
            view?.updatePaymentAmounts(with: selectedOperator?.topupValues, selectedValue: selectedTopUpValue)
        }
    }
    
    private var selectedTopUpValue: TopUpValue? {
        didSet {
            view?.updatePaymentAmounts(with: selectedOperator?.topupValues, selectedValue: selectedTopUpValue)
        }
    }
        
    private var recipientName: String = "" {
        didSet {
            view?.updateRecipientName(with: recipientName)
        }
    }
    
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
        self.polishContactsFilter = dependenciesResolver.resolve(for: PolishContactsFiltering.self)
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
        phoneNumber = .partial(number: number)
    }
    
    func didInputFullPhoneNumber(_ number: String) {
        phoneNumber = .full(number: number)
    }
    
    func mobileContactsDidSelectContact(_ contact: MobileContact) {
        phoneNumber = .full(number: contact.phoneNumber)
        recipientName = contact.fullName
    }
    
    func didSelectTopUpAmount(_ value: TopUpValue?) {
        selectedTopUpValue = value
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
        coordinator?.showOperatorSelection(currentlySelectedOperatorId: selectedGsmOperator?.id)
    }
    
    func didSelectOperator(_ gsmOperator: GSMOperator) {
        selectedGsmOperator = gsmOperator
    }
}

private extension PhoneTopUpFormPresenter {
    func validatePhoneNumber() {
        switch phoneNumber {
        case .partial(_):
            view?.showInvalidPhoneNumberError(false)
        case .full(let number):
            let showError = matchGSMOperator(with: number) == nil
            view?.showInvalidPhoneNumberError(showError)
        }
    }
    
    func updateRecipientName() {
        switch phoneNumber {
        case .partial(_):
            recipientName = ""
        case .full(let number):
            recipientName = ""
            let phoneNumberDigits = number.filter(\.isNumber)
            if let internetContact = internetContacts.first(where: { $0.phoneNumberDigits == phoneNumberDigits }) {
                recipientName = internetContact.fullName
                return
            }
            
            getPhoneContacts { [weak self] contacts in
                if let phoneContact = contacts.first(where: { $0.phoneNumberDigits == phoneNumberDigits }) {
                    self?.recipientName = phoneContact.fullName
                }
            }
        }
    }
    
    func updateOperator() {
        switch phoneNumber {
        case .partial(_):
            selectedGsmOperator = nil
        case .full(let number):
            selectedGsmOperator = matchGSMOperator(with: number)
        }
    }
    
    func matchGSMOperator(with number: String) -> GSMOperator? {
        let operatorId = operators.first(where: { $0.prefixes.first(where: { number.starts(with: $0) }) != nil })?.id
        return gsmOperators.first(where: { $0.id == operatorId })
    }
    
    func showPhoneContacts() {
        getPhoneContacts { [weak self] contacts in
            self?.coordinator?.showPhoneContacts(contacts)
        }
    }
    
    func getPhoneContacts(success: @escaping ([MobileContact]) -> Void) {
        Scenario(useCase: getPhoneContactsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                let polishContacts = self?.polishContactsFilter.filterAndFormatPolishContacts(output.contacts) ?? []
                success(polishContacts)
            }.onError { error in
                success([])
            }
    }
}
