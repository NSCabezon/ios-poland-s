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
    func didSelectTopUpAmount(_ amount: TopUpAmount)
    func didTouchContinueButton()
    func didTouchOperatorSelectionButton()
    func didTouchTermsAndConditionsCheckBox()
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
    private let settings: TopUpSettings
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let accountMapper: SelectableAccountViewModelMapping
    private let getPhoneContactsUseCase: GetContactsUseCaseProtocol
    private let useCaseHandler: UseCaseHandler
    private let contactsPermissionHelper: ContactsPermissionHelperProtocol
    private let polishContactsFilter: PolishContactsFiltering
    private let customTopUpAmountValidator: CustomTopUpAmountValidating
    private let amountCellViewModelMapper: PaymentAmountCellViewModelMapping
    
    private var selectedAccount: AccountForDebit? {
        didSet {
            let viewModels = accounts.compactMap({ try? accountMapper.map($0, selectedAccountNumber: selectedAccount?.number) })
            view?.updateSelectedAccount(with: viewModels)
            validateCustomTopUpAmount()
        }
    }
    
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
            selectedTopUpAmount = matchDefaultTopUpAmount(with: selectedOperator)
            termsAccepted = false
            let amountViewModels = amountCellViewModelMapper.map(topUpValues: selectedOperator?.topupValues, selectedAmount: selectedTopUpAmount)
            view?.updatePaymentAmounts(with: amountViewModels, selectedAmount: selectedTopUpAmount)
        }
    }
    
    private var selectedTopUpAmount: TopUpAmount? {
        didSet {
            let amountViewModels = amountCellViewModelMapper.map(topUpValues: selectedOperator?.topupValues, selectedAmount: selectedTopUpAmount)
            view?.updatePaymentAmounts(with: amountViewModels, selectedAmount: selectedTopUpAmount)
            validateCustomTopUpAmount()
        }
    }
    
    private var isTermsAcceptanceRequired: Bool {
        get {
            return settings.first(where: { $0.operatorId == selectedOperator?.id })?.requestAcceptance ?? false
        }
    }
    
    private var termsAccepted: Bool = false {
        didSet {
            view?.updateTermsView(isAcceptanceRequired: isTermsAcceptanceRequired, isAccepted: termsAccepted)
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
         internetContacts: [MobileContact],
         settings: TopUpSettings) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.operators = operators
        self.gsmOperators = gsmOperators
        self.internetContacts = internetContacts
        self.settings = settings
        self.coordinator = dependenciesResolver.resolve(for: PhoneTopUpFormCoordinatorProtocol.self)
        self.confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
        self.accountMapper = dependenciesResolver.resolve(for: SelectableAccountViewModelMapping.self)
        self.selectedAccount = accounts.first(where: \.defaultForPayments)
        self.getPhoneContactsUseCase = dependenciesResolver.resolve(for: GetContactsUseCaseProtocol.self)
        self.useCaseHandler = dependenciesResolver.resolve(for: UseCaseHandler.self)
        self.contactsPermissionHelper = dependenciesResolver.resolve(for: ContactsPermissionHelperProtocol.self)
        self.polishContactsFilter = dependenciesResolver.resolve(for: PolishContactsFiltering.self)
        self.customTopUpAmountValidator = dependenciesResolver.resolve(for: CustomTopUpAmountValidating.self)
        self.amountCellViewModelMapper = dependenciesResolver.resolve(for: PaymentAmountCellViewModelMapping.self)
    }
}

// MARK: PhoneTopUpFormPresenterProtocol
extension PhoneTopUpFormPresenter: PhoneTopUpFormPresenterProtocol {
    func viewDidLoad() {
        let viewModels = accounts.compactMap({ try? accountMapper.map($0, selectedAccountNumber: selectedAccount?.number) })
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
        selectedAccount = accounts.first(where: { $0.number == accountNumber })
    }
    
    func didSelectChangeAccount() {
        coordinator?.didSelectChangeAccount(availableAccounts: accounts, selectedAccountNumber: selectedAccount?.number)
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
    
    func didSelectTopUpAmount(_ amount: TopUpAmount) {
        selectedTopUpAmount = amount
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
    
    func didTouchTermsAndConditionsCheckBox() {
        termsAccepted = !termsAccepted
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
    
    func validateCustomTopUpAmount() {
        let minValue = selectedOperator?.topupValues.min
        let maxValue = selectedOperator?.topupValues.max
        let availableFunds = selectedAccount?.availableFunds.amount
        let validationResults = customTopUpAmountValidator.validate(amount: selectedTopUpAmount,
                                                                    minAmount: minValue,
                                                                    maxAmount: maxValue,
                                                                    availableFunds: availableFunds)
        switch validationResults {
        case .valid:
            view?.showInvalidCustomAmountError(nil)
        case .error(let message):
            view?.showInvalidCustomAmountError(message)
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
    
    func matchDefaultTopUpAmount(with mobileOperator: Operator?) -> TopUpAmount? {
        guard let mobileOperator = mobileOperator else {
            return nil
        }
    
        let matchingOperatorSetting = settings.first(where: { $0.operatorId == mobileOperator.id })
        guard let matchingTopUpValue = mobileOperator.topupValues.values.first(where: { $0.value == matchingOperatorSetting?.defaultTopUpValue }) else {
            return nil
        }
        
        return .fixed(matchingTopUpValue)
    }
}
